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
Создаем network manager. Воспользуемся библиотекой dio. Настраиваем автообновление токена, и logout.


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
Создаем функцию записи получения токенов и записываем их в безопасное хронилище. 

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
