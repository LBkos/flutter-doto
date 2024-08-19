import 'package:task_manager/widgets/tasks/create_task.dart';
import 'package:task_manager/widgets/start.dart';

import '../widgets/registration.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/widgets/tasks/home.dart';
import 'package:task_manager/widgets/login.dart';

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const Start();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return const Login();
          },
        ),
        GoRoute(
            path: 'registration',
            builder: (context, state) {
              return const Registration();
            }),
        GoRoute(
          path: 'createTask',
          builder: (context, state) {
            return const CreateTask();
          },
        ),
      ]),
]);
