// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      sid: json['sid'] as String,
      isDone: json['isDone'] as bool,
      title: json['title'] as String,
      text: json['text'] as String,
      finishAt: DateTime.parse(json['finishAt'] as String),
      priority: (json['priority'] as num).toInt(),
      tag: Tag.fromJson(json['tag'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'isDone': instance.isDone,
      'title': instance.title,
      'text': instance.text,
      'finishAt': instance.finishAt.toIso8601String(),
      'priority': instance.priority,
      'tag': instance.tag,
      'createdAt': instance.createdAt.toIso8601String(),
    };
