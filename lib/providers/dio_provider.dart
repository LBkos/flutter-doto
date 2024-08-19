// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/models/login_model.dart';
import 'package:task_manager/models/task.dart';
import 'navigation_service.dart';

const storage = FlutterSecureStorage();
final _router = router;

class DioProvider {
  Dio init() {
    Dio dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        var access = await storage.read(key: 'accessToken');
        options.headers['Authorization'] = 'Bearer $access';

        return handler.next(options);
      },
      onError: (error, handler) async {
        debugPrint(error.error.toString());
        if (error.response?.statusCode == 401) {
          final data = await refreshToken();
          final accessToken = data.accessToken;
          error.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

          return handler.resolve(await dio.fetch(error.requestOptions));
        } else if (error.response?.statusCode == 500) {
          storage.delete(key: 'accessToken');
          storage.delete(key: 'refreshToken');
          _router.pushReplacement('/login');
        } else {
          debugPrint(error.error.toString());
        }
        handler.next(error);
      },
    ));
    dio.options.baseUrl = 'https://test-mobile.estesis.tech/api/v1/';

    return dio;
  }

  Future<bool> loginIn(
      String username, String password, BuildContext context) async {
    final dio = init();
    dio.options.headers['Content-Type'] = Headers.formUrlEncodedContentType;
    Response<dynamic> response = await dio
        .post('login', data: {'username': username, 'password': password});
    // print(response);
    final data = LoginModel.fromJson(response.data);

    storage.write(key: 'refreshToken', value: data.refreshToken);
    storage.write(key: 'accessToken', value: data.accessToken);

    // ignore: use_build_context_synchronously
    context.pushReplacement('/home');
    return false;
  }

  Future<LoginModel> refreshToken() async {
    String? refreshT = await storage.read(key: 'refreshToken');
    final dio = DioProvider().init();
    final response = await dio
        .post('refresh_token', queryParameters: {'refresh_token': refreshT});
    final data = LoginModel.fromJson(response.data);
    storage.write(key: 'refreshToken', value: data.refreshToken);
    storage.write(key: "accessToken", value: data.accessToken);

    return data;
  }

  Future<void> deleteTask(String sid) async {
    final dio = init();
    dio.options.headers['Content-Type'] = Headers.jsonContentType;
    Response<dynamic> _ =
        await dio.delete('tasks', queryParameters: {'taskSid': sid});
    // final data = Task.fromJson(response.data);
  }

  Future<void> changeTask(Task task) async {
    final dio = init();
    dio.options.headers['Content-Type'] = Headers.jsonContentType;
    Response<dynamic> _ = await dio.put('tasks', data: {
      'title': task.title,
      'text': task.text,
      'finishAt': task.finishAt.toIso8601String(),
      'priority': task.priority,
      'tagSid': task.tag.sid,
      'isDone': task.isDone,
      'sid': task.sid
    });
    // final data = Task.fromJson(response.data);
  }
}
