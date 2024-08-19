// task_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager/providers/tasks_provider.dart';
// import 'package:task_manager/widgets/tasks/create_task.dart';
import 'task_item.dart';

// ignore: must_be_immutable
class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key});

  @override
  ConsumerState createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(todosNotifierProvider);
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: ListView.builder(
          key: UniqueKey(),
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dismissible(
                  key: Key(tasks[index].sid),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      ref
                          .watch(todosNotifierProvider.notifier)
                          .delete(tasks[index].sid);
                    }
                  },
                  onUpdate: (details) {},
                  background: Container(
                      decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  )),
                  secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 36,
                      )),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE9F1FF)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: TaskItem(index: index),
                  )),
            );
          },
        ),
      ),
    );
  }
}
