class SubscriptionState {
  const SubscriptionState._({
    required this.isLoading,
    required this.isSuccess,
    this.error,
    this.stackTrace,
  });

  const SubscriptionState.idle() : this._(isLoading: false, isSuccess: false);
  const SubscriptionState.loading()
      : this._(isLoading: true, isSuccess: false);
  const SubscriptionState.success()
      : this._(isLoading: false, isSuccess: true);
  const SubscriptionState.error(Object error, StackTrace stackTrace)
      : this._(
          isLoading: false,
          isSuccess: false,
          error: error,
          stackTrace: stackTrace,
        );

  final bool isLoading;
  final bool isSuccess;
  final Object? error;
  final StackTrace? stackTrace;

  bool get hasError => error != null;
}
