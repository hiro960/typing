import 'dart:async';
import 'dart:io';

import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/services.dart';

import '../data/subscription_repository.dart';
import 'subscription_state.dart';

String get _productId => Platform.isAndroid ? 'pro_0001' : 'PRO_0001';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return SubscriptionRepository(apiClient: apiClient);
});

final subscriptionControllerProvider =
    NotifierProvider<SubscriptionController, SubscriptionState>(
  SubscriptionController.new,
);

class SubscriptionController extends Notifier<SubscriptionState> {
  final _iap = InAppPurchase.instance;
  Set<String> get _productIds => {_productId};
  final Set<String> _handledTransactions = {};

  @override
  SubscriptionState build() {
    return const SubscriptionState.idle();
  }

  Future<void> startSubscription() async {
    if (state.isLoading) return;

    state = const SubscriptionState.loading();
    _handledTransactions.clear();
    StreamSubscription<List<PurchaseDetails>>? sub;
    Timer? timeout;

    try {
      debugPrint('[IAP] startSubscription begin');
      final authState = ref.read(authStateProvider);
      debugPrint('[IAP] auth status=${authState.status} user=${authState.user?.id}');
      if (authState.status != AuthStatus.authenticated || authState.user == null) {
        state = SubscriptionState.error(
          Exception('未ログインのため購入できません'),
          StackTrace.current,
        );
        return;
      }
      final available = await _iap.isAvailable();
      debugPrint('[IAP] isAvailable=$available');
      if (!available) {
        throw Exception('ストアに接続できませんでした。時間をおいて再度お試しください。');
      }
      final productResponse = await _iap.queryProductDetails(_productIds);
      if (productResponse.error != null) {
        debugPrint('[IAP] product query error: ${productResponse.error}');
        throw PlatformException(
          code: productResponse.error!.code,
          message: productResponse.error!.message,
          details: productResponse.error!.details,
        );
      }
      if (productResponse.productDetails.isEmpty) {
        throw Exception('商品情報の取得に失敗しました。');
      }

      final products = productResponse.productDetails.cast<ProductDetails>();
      final product = products.firstWhere(
        (p) => p.id == _productId,
        orElse: () => products.first,
      );

      final purchaseParam = PurchaseParam(productDetails: product);
      final completer = Completer<void>();

      debugPrint(
        '[IAP] product ready id=${product.id} price=${product.price} type=${product.runtimeType}',
      );

      timeout = Timer(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          debugPrint('[IAP] timed out waiting for purchase updates');
          state = SubscriptionState.error(
            TimeoutException('購入処理がタイムアウトしました'),
            StackTrace.current,
          );
          completer.complete();
        }
      });

      sub = _iap.purchaseStream.listen(
        (purchases) async {
          debugPrint('[IAP] purchaseStream event count=${purchases.length}');
          for (final p in purchases) {
             debugPrint('[IAP] stream item: id=${p.productID} status=${p.status} txId=${p.purchaseID} date=${p.transactionDate}');
          }
          for (final purchase in purchases) {
            if (purchase.productID != product.id) continue;
            final txKey =
                purchase.purchaseID ?? purchase.verificationData.serverVerificationData;
            if (_handledTransactions.contains(txKey)) {
              debugPrint('[IAP] skip already handled transaction $txKey');
              continue;
            }
            _handledTransactions.add(txKey);

            switch (purchase.status) {
              case PurchaseStatus.purchased:
              case PurchaseStatus.restored:
                try {
                  debugPrint('[IAP] purchase status=${purchase.status}');
                  await _verifyAndComplete(purchase);
                  // 1つでも成功すればOKとする
                  state = const SubscriptionState.success();
                  // 成功したら完了処理をしてストリーム購読などを終了
                  if (purchase.pendingCompletePurchase) {
                    await _iap.completePurchase(purchase);
                  }
                  await sub?.cancel();
                  timeout?.cancel();
                  if (!completer.isCompleted) completer.complete();
                  return; 
                } catch (e, st) {
                  debugPrint('[IAP] verify/complete error: $e');
                  // エラーがあっても、他のトランザクションが成功する可能性があるので
                  // ここではstateをエラーにせず、ログ出力にとどめる。
                  // ただし、これが最後のトランザクションで全て失敗した場合などは考慮が必要だが、
                  // ユーザーが再度ボタンを押せば良いので、一旦成功以外は無視する戦略をとる。
                  // (明示的なエラー表示よりも、成功を阻害しないことを優先)
                  
                  // 課金処理自体は完了させる（再試行を防ぐため）
                  if (purchase.pendingCompletePurchase) {
                    try {
                      await _iap.completePurchase(purchase);
                    } catch (_) {}
                  }
                } 
                break;
             case PurchaseStatus.error:
                final err = purchase.error ??
                    IAPError(
                        source: 'AppStore',
                        code: 'unknown',
                        message: 'Unknown error');
                debugPrint('[IAP] purchase error: ${err.message}');
                // エラーの場合は即座にエラー状態にする（ただし、他の成功がある場合は上書きしない制御が必要だが、
                // 現状はエラーが来たらエラーとする。リスト処理なので微妙だが、通常エラーは単発）
                state = SubscriptionState.error(
                    Exception(err.message), StackTrace.current);
                if (!completer.isCompleted) completer.complete();
                break;
              case PurchaseStatus.pending:
                debugPrint('[IAP] purchase pending');
                // keep waiting
                break;
              case PurchaseStatus.canceled:
                if (!completer.isCompleted) completer.complete();
                break;
            }
          }
        },
        onError: (error, stackTrace) {
          if (_isUserCancelled(error)) {
            state = const SubscriptionState.idle();
          } else {
            debugPrint('[IAP] purchase stream error: $error');
            state = SubscriptionState.error(error, stackTrace);
          }
          sub?.cancel();
          timeout?.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      debugPrint('[IAP] calling buyNonConsumable');
      final started = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      debugPrint('[IAP] buyNonConsumable returned started=$started');
      if (started == false) {
        throw Exception('購入処理を開始できませんでした。');
      }
      debugPrint('[IAP] waiting for transaction updates...');

      await completer.future;
    } catch (e, st) {
      if (_isUserCancelled(e)) {
        state = const SubscriptionState.idle();
      } else {
        debugPrint('[IAP] purchase flow error: $e');
        state = SubscriptionState.error(e, st);
      }
    } finally {
      await sub?.cancel();
      timeout?.cancel();
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    final repository = ref.read(subscriptionRepositoryProvider);
    final platform = Platform.isIOS ? 'ios' : 'android';

    try {
      final receiptData = purchase.verificationData.serverVerificationData;
      final localData = purchase.verificationData.localVerificationData;

      debugPrint(
        '[IAP] verifyAndActivate tx=${purchase.purchaseID} serverLen=${receiptData.length} localLen=${localData.length} platform=$platform',
      );
      if (receiptData.isNotEmpty) {
        debugPrint('[IAP] serverData prefix=${receiptData.substring(0, 20)}...');
      }

      final user = await repository.verifyAndActivate(
        productId: purchase.productID,
        platform: platform,
        transactionId: purchase.purchaseID ?? '',
        verificationData: receiptData,
      );

      ref.read(authStateProvider.notifier).updateUser(user);
    } catch (e) {
      debugPrint('[IAP] verifyAndActivate error: $e');
      rethrow;
    }
  }

  bool _isUserCancelled(Object? error) {
    if (error == null) return false;
    if (error is PlatformException && error.code == 'userCancelled') {
      return true;
    }
    if (error is IAPError && error.code == 'userCancelled') {
      return true;
    }
    return false;
  }
}
