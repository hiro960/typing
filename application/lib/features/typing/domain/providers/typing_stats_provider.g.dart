// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(typingStats)
const typingStatsProvider = TypingStatsFamily._();

final class TypingStatsProvider
    extends
        $FunctionalProvider<TypingStatsData, TypingStatsData, TypingStatsData>
    with $Provider<TypingStatsData> {
  const TypingStatsProvider._({
    required TypingStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'typingStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$typingStatsHash();

  @override
  String toString() {
    return r'typingStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TypingStatsData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TypingStatsData create(Ref ref) {
    final argument = this.argument as String;
    return typingStats(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TypingStatsData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TypingStatsData>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TypingStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$typingStatsHash() => r'205953be1c23b5ab3b0a47e0ff270cc8185ed5ef';

final class TypingStatsFamily extends $Family
    with $FunctionalFamilyOverride<TypingStatsData, String> {
  const TypingStatsFamily._()
    : super(
        retry: null,
        name: r'typingStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TypingStatsProvider call(String lessonId) =>
      TypingStatsProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'typingStatsProvider';
}
