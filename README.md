# Task Manager
Test project on flutter framework

### Login

Для входа в приложение создаем модель данных ответа с использованием freezed. https://pub.dev/packages/freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({
    required String accessToken,
    required String refreshToken,
  }) = _LoginModel;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}

```
В сгенерированном файле login_model.g.dart нужно исправить имена полей аналогично с файлом json
```dart

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,

```
Создаем network manager. Воспользуемся библиотекой dio(https://pub.dev/packages/dio). Настраиваем автообновление токена, и logout.

```dart
import 'package:dio/dio.dart';
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

```
Создаем функцию записи получения токенов и записываем их в FlutterSecureStorage. https://pub.dev/packages/flutter_secure_storage 

```dart
Future<bool> loginIn(
      String username, String password, BuildContext context) async {
    final dio = init();
    dio.options.headers['Content-Type'] = Headers.formUrlEncodedContentType;
    Response<dynamic> response = await dio
        .post('login', data: {'username': username, 'password': password});

    final data = LoginModel.fromJson(response.data);

    storage.write(key: 'refreshToken', value: data.refreshToken);
    storage.write(key: 'accessToken', value: data.accessToken);

    context.pushReplacement('/home');
    return false;
  }
```

Создаем provider для монипуляции данных о задачах.

```dart
class TodoList extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    final tasks = ref.read(getTasksProvider);
    return tasks.value?.items ?? [];
  }

  void delete(String id) {
    final result = state.where((element) => element.sid != id);
    state = [...result];
    DioProvider().deleteTask(id);
  }

  void toggle(String id) {
    final dio = DioProvider();
    state = [
      for (final task in state)
        if (task.sid == id)
          Task(
              sid: id,
              isDone: !task.isDone,
              title: task.title,
              text: task.text,
              finishAt: task.finishAt,
              priority: task.priority,
              tag: task.tag,
              createdAt: task.createdAt)
        else
          task,
    ];
    // print(state.firstWhere((task) => task.sid == id));
    dio.changeTask(state.firstWhere((task) => task.sid == id));
  }
}

final todosNotifierProvider =
    NotifierProvider<TodoList, List<Task>>(TodoList.new);

```

Получаем данные о задачах с помощью riverpod(https://pub.dev/packages/riverpod)

```dart
@riverpod
Future<TasksModel> getTasks(GetTasksRef ref) async {
  final dio = DioProvider().init();
  final response =
      await dio.get('/tasks', queryParameters: {'limit': '50', 'offset': '0'});

  return TasksModel.fromJson(response.data);
}
```

С помощью утилиты безопасного монипулирования асинхронными данными AsyncValue(https://pub.dev/documentation/riverpod/latest/riverpod/AsyncValue-class.html) отслеживаем состояние загрузки и показываем необходимый виджет.

```dart
AsyncValue<TasksModel> tasks(WidgetRef ref) => ref.watch(getTasksProvider);

Container(
                  child: switch (widget.tasks(ref)) {
                    AsyncLoading() => const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CenteredProgressView(),
                      ),
                    AsyncData() => const TaskList(),
                    AsyncError() => const Text('Oops, something happened'),
                    AsyncValue<TasksModel>() => throw UnimplementedError(),
                  },
                )
```