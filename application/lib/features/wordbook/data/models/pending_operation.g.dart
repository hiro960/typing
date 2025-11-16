// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingOperation _$PendingOperationFromJson(Map<String, dynamic> json) =>
    _PendingOperation(
      id: json['id'] as String,
      operationType: json['operationType'] as String,
      tempId: json['tempId'] as String?,
      wordId: json['wordId'] as String?,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt'] as String),
    );

Map<String, dynamic> _$PendingOperationToJson(_PendingOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operationType': instance.operationType,
      'tempId': instance.tempId,
      'wordId': instance.wordId,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
      'retryCount': instance.retryCount,
      'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
    };
