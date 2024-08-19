import 'package:freezed_annotation/freezed_annotation.dart';
// import 'dart:convert';

import 'task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TasksModel with _$TasksModel {
  const factory TasksModel({
    required List<Task> items,
    required int total,
    required int limit,
    required int offset,
  }) = _TasksModel;

  factory TasksModel.fromJson(Map<String, dynamic> json) =>
      _$TasksModelFromJson(json);
}
