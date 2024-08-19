import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/providers/dio_provider.dart';
part 'tasks_provider.g.dart';

@riverpod
Future<TasksModel> getTasks(GetTasksRef ref) async {
  final dio = DioProvider().init();
  final response =
      await dio.get('/tasks', queryParameters: {'limit': '50', 'offset': '0'});

  return TasksModel.fromJson(response.data);
}

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
