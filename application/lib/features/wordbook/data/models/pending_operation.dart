// ignore_for_file: non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_operation.freezed.dart';
part 'pending_operation.g.dart';

@freezed
abstract class PendingOperation with _$PendingOperation {
  const factory PendingOperation({
    required String id,
    required String operationType,
    String? tempId,
    String? wordId,
    required Map<String, dynamic> data,
    required DateTime createdAt,
    @Default(0) int retryCount,
    DateTime? lastAttemptAt,
  }) = _PendingOperation;

  factory PendingOperation.fromJson(Map<String, dynamic> json) =>
      _$PendingOperationFromJson(json);
}
