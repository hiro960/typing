import 'dart:async';
import 'dart:io';

import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
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
    Object? lastExpiredError;
    StackTrace? lastExpiredStackTrace;

    try {
      final authState = ref.read(authStateProvider);
      if (authState.status != AuthStatus.authenticated || authState.user == null) {
        state = SubscriptionState.error(
          Exception('未ログインのため購入できません'),
          StackTrace.current,
        );
        return;
      }
      final available = await _iap.isAvailable();
      if (!available) {
        throw Exception('ストアに接続できませんでした。時間をおいて再度お試しください。');
      }
      final productResponse = await _iap.queryProductDetails(_productIds);
      if (productResponse.error != null) {
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

      timeout = Timer(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          // 期限切れエラーがあった場合はそれを表示、なければタイムアウトエラー
          if (lastExpiredError != null) {
            state = SubscriptionState.error(
              lastExpiredError!,
              lastExpiredStackTrace ?? StackTrace.current,
            );
          } else {
            state = SubscriptionState.error(
              TimeoutException('購入処理がタイムアウトしました'),
              StackTrace.current,
            );
          }
          completer.complete();
        }
      });

      sub = _iap.purchaseStream.listen(
        (purchases) async {
          for (final purchase in purchases) {
            if (purchase.productID != product.id) continue;
            final txKey =
                purchase.purchaseID ?? purchase.verificationData.serverVerificationData;
            if (_handledTransactions.contains(txKey)) {
              continue;
            }
            _handledTransactions.add(txKey);

            switch (purchase.status) {
              case PurchaseStatus.purchased:
              case PurchaseStatus.restored:
                try {
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
                  // 課金処理自体は完了させる（再試行を防ぐため）
                  if (purchase.pendingCompletePurchase) {
                    try {
                      await _iap.completePurchase(purchase);
                    } catch (_) {}
                  }
                  // 期限切れエラーの場合は次のトランザクションを待つ
                  if (_isExpiredError(e)) {
                    lastExpiredError = e;
                    lastExpiredStackTrace = st;
                    // 次のトランザクションを待つため、ここでは終了しない
                  } else {
                    // その他のエラーは即座にエラー状態にする
                    state = SubscriptionState.error(e, st);
                    await sub?.cancel();
                    timeout?.cancel();
                    if (!completer.isCompleted) completer.complete();
                    return;
                  }
                }
             case PurchaseStatus.error:
                final err = purchase.error ??
                    IAPError(
                        source: 'AppStore',
                        code: 'unknown',
                        message: 'Unknown error');
                // エラーの場合は即座にエラー状態にする（ただし、他の成功がある場合は上書きしない制御が必要だが、
                // 現状はエラーが来たらエラーとする。リスト処理なので微妙だが、通常エラーは単発）
                state = SubscriptionState.error(
                    Exception(err.message), StackTrace.current);
                if (!completer.isCompleted) completer.complete();
                break;
              case PurchaseStatus.pending:
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
            state = SubscriptionState.error(error, stackTrace);
          }
          sub?.cancel();
          timeout?.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      final started = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      if (started == false) {
        throw Exception('購入処理を開始できませんでした。');
      }

      await completer.future;
    } catch (e, st) {
      if (_isUserCancelled(e)) {
        state = const SubscriptionState.idle();
      } else {
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

    final receiptData = purchase.verificationData.serverVerificationData;

    final user = await repository.verifyAndActivate(
      productId: purchase.productID,
      platform: platform,
      transactionId: purchase.purchaseID ?? '',
      verificationData: receiptData,
    );

    ref.read(authStateProvider.notifier).updateUser(user);
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

  /// エラーが「期限切れ」エラーかどうかを判断する
  bool _isExpiredError(Object? error) {
    if (error == null) return false;
    final errorString = error.toString().toLowerCase();
    return errorString.contains('expired') ||
        errorString.contains('subscription has expired');
  }

  /// 過去の購入情報を復元する
  Future<void> restorePurchases() async {
    if (state.isLoading) return;

    state = const SubscriptionState.loading();
    _handledTransactions.clear();
    StreamSubscription<List<PurchaseDetails>>? sub;
    Timer? timeout;
    bool foundPurchase = false;
    Object? lastExpiredError;
    StackTrace? lastExpiredStackTrace;

    try {
      final authState = ref.read(authStateProvider);
      if (authState.status != AuthStatus.authenticated ||
          authState.user == null) {
        state = SubscriptionState.error(
          Exception('未ログインのため復元できません'),
          StackTrace.current,
        );
        return;
      }

      final available = await _iap.isAvailable();
      if (!available) {
        throw Exception('ストアに接続できませんでした。時間をおいて再度お試しください。');
      }

      final completer = Completer<void>();

      // タイムアウト設定（30秒）
      timeout = Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          // 期限切れエラーがあった場合はそれを表示
          if (lastExpiredError != null) {
            state = SubscriptionState.error(
              lastExpiredError!,
              lastExpiredStackTrace ?? StackTrace.current,
            );
          } else if (!foundPurchase) {
            state = SubscriptionState.error(
              Exception('復元できる購入情報が見つかりませんでした'),
              StackTrace.current,
            );
          }
          completer.complete();
        }
      });

      sub = _iap.purchaseStream.listen(
        (purchases) async {
          for (final purchase in purchases) {
            if (purchase.productID != _productId) continue;

            final txKey = purchase.purchaseID ??
                purchase.verificationData.serverVerificationData;
            if (_handledTransactions.contains(txKey)) {
              continue;
            }
            _handledTransactions.add(txKey);

            if (purchase.status == PurchaseStatus.restored) {
              foundPurchase = true;
              try {
                await _verifyAndComplete(purchase);
                state = const SubscriptionState.success();

                if (purchase.pendingCompletePurchase) {
                  await _iap.completePurchase(purchase);
                }
                await sub?.cancel();
                timeout?.cancel();
                if (!completer.isCompleted) completer.complete();
                return;
              } catch (e, st) {
                if (purchase.pendingCompletePurchase) {
                  try {
                    await _iap.completePurchase(purchase);
                  } catch (_) {}
                }
                // 期限切れエラーの場合は次のトランザクションを待つ
                if (_isExpiredError(e)) {
                  lastExpiredError = e;
                  lastExpiredStackTrace = st;
                  // 次のトランザクションを待つため、ここでは終了しない
                } else {
                  // その他のエラーは即座にエラー状態にする
                  state = SubscriptionState.error(e, st);
                  await sub?.cancel();
                  timeout?.cancel();
                  if (!completer.isCompleted) completer.complete();
                  return;
                }
              }
            }
          }
        },
        onError: (error, stackTrace) {
          state = SubscriptionState.error(error, stackTrace);
          sub?.cancel();
          timeout?.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      await _iap.restorePurchases();

      // 復元イベントが来るのを待つ（タイムアウトまで）
      await completer.future;
    } catch (e, st) {
      state = SubscriptionState.error(e, st);
    } finally {
      await sub?.cancel();
      timeout?.cancel();
    }
  }
}
