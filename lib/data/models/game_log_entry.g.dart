// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameLogEntryImpl _$$GameLogEntryImplFromJson(Map<String, dynamic> json) =>
    _$GameLogEntryImpl(
      id: json['id'] as String,
      promptVersion: json['promptVersion'] as String,
      category: json['category'] as String,
      categoryDescription: json['categoryDescription'] as String,
      civilian: json['civilian'] as String,
      infiltrator: json['infiltrator'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      civilianFeedback: json['civilianFeedback'] as bool?,
      infiltratorFeedback: json['infiltratorFeedback'] as bool?,
      notes: json['notes'] as String?,
      thoughtProcess: json['thoughtProcess'] as String?,
    );

Map<String, dynamic> _$$GameLogEntryImplToJson(_$GameLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'promptVersion': instance.promptVersion,
      'category': instance.category,
      'categoryDescription': instance.categoryDescription,
      'civilian': instance.civilian,
      'infiltrator': instance.infiltrator,
      'timestamp': instance.timestamp.toIso8601String(),
      'civilianFeedback': instance.civilianFeedback,
      'infiltratorFeedback': instance.infiltratorFeedback,
      'notes': instance.notes,
      'thoughtProcess': instance.thoughtProcess,
    };
