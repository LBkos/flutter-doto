import 'package:freezed_annotation/freezed_annotation.dart';
// import 'dart:convert';
import 'tag.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String sid,
    required bool isDone,
    required String title,
    required String text,
    required DateTime finishAt,
    required int priority,
    required Tag tag,
    required DateTime createdAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
