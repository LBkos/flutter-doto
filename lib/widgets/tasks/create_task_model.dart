import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/dio_provider.dart';

class CreateTaskModel {
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime =
      TimeOfDay(hour: DateTime.now().hour + 1, minute: DateTime.now().minute);
  final taskNameController = TextEditingController();
  final taskTextController = TextEditingController();
  bool isPresentedEnd = false;
  Task? task;

  Future<void> createTask(BuildContext context) async {
    final _ = startDate
        .add(Duration(hours: startTime.hour, minutes: startTime.minute));
    final end =
        endDate.add(Duration(hours: endTime.hour, minutes: endTime.minute));
    final dio = DioProvider().init();
    dio.options.headers['Content-Type'] = Headers.jsonContentType;
    Response<dynamic> response = await dio.post('tasks', data: {
      "tagSid": "3b4742c0-eeda-4db4-a44a-1a180f580b13",
      "title": taskNameController.text,
      "text": taskTextController.text,
      "finishAt": end.toIso8601String(),
      "priority": 2
    });
    if (response.statusCode == 200) {
      taskNameController.text = '';
      taskTextController.text = '';
      isPresentedEnd = false;
    }
    final data = Task.fromJson(response.data);
    task = data;

    // ignore: use_build_context_synchronously
    context.pop(data);
  }
}
