// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DeepL翻訳サービスプロバイダー

@ProviderFor(deeplTranslationService)
const deeplTranslationServiceProvider = DeeplTranslationServiceProvider._();

/// DeepL翻訳サービスプロバイダー

final class DeeplTranslationServiceProvider
    extends
        $FunctionalProvider<
          DeepLTranslationService,
          DeepLTranslationService,
          DeepLTranslationService
        >
    with $Provider<DeepLTranslationService> {
  /// DeepL翻訳サービスプロバイダー
  const DeeplTranslationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deeplTranslationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deeplTranslationServiceHash();

  @$internal
  @override
  $ProviderElement<DeepLTranslationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeepLTranslationService create(Ref ref) {
    return deeplTranslationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLTranslationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLTranslationService>(value),
    );
  }
}

String _$deeplTranslationServiceHash() =>
    r'184c21693bf2bd2a1c042cb8f7a34cd926abd91a';

/// 翻訳機能のNotifierプロバイダー

@ProviderFor(TranslationController)
const translationControllerProvider = TranslationControllerProvider._();

/// 翻訳機能のNotifierプロバイダー
final class TranslationControllerProvider
    extends $NotifierProvider<TranslationController, TranslationState> {
  /// 翻訳機能のNotifierプロバイダー
  const TranslationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationControllerHash();

  @$internal
  @override
  TranslationController create() => TranslationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranslationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranslationState>(value),
    );
  }
}

String _$translationControllerHash() =>
    r'80e73bfbb69eeef50bf5e79c37c1b479ae1f293e';

/// 翻訳機能のNotifierプロバイダー

abstract class _$TranslationController extends $Notifier<TranslationState> {
  TranslationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TranslationState, TranslationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TranslationState, TranslationState>,
              TranslationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
