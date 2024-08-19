import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/helps_view/BorderedTextField.dart';
import 'package:task_manager/providers/tasks_provider.dart';
import 'package:task_manager/helps_view/date_text.dart';
import '../../helps_view/centered_progress_view.dart';
import 'task_list.dart';

const storage = FlutterSecureStorage();

class HomeScreen extends ConsumerStatefulWidget with HomeState {
  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

final now = DateTime.now();

class _HomeState extends ConsumerState<HomeScreen> {
  var list = List<int>.generate(20, (i) => i + 1);
  int count = 0;
  final DateTime date = now.subtract(const Duration(days: 2));
  DateTime selectDate = now;
  late DateFormat dateFormat;
  late DateFormat
      dayFormat; //= DateFormat('EEEE', 'ru').format(DateTime.now());
  List<Task>? tasks;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dayFormat = DateFormat.E('ru');
    dateFormat = DateFormat.MMMMd('ru');
  }

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Мои задачи'),
            leading: IconButton(
                onPressed: () => {
                      storage.delete(key: 'accessToken'),
                      storage.delete(key: 'refreshToken'),
                      context.pushReplacement('/login')
                    },
                icon: const Icon(Icons.exit_to_app)),
            actions: [
              IconButton(
                  onPressed: () async {
                    context.push('/createTask').then((task) => setState(() {
                          if (task != null) {
                            // ignore: unused_result
                            ref.refresh(getTasksProvider);
                          }
                        }));
                  },
                  icon: const Image(image: AssetImage('images/Plus.png')))
            ],
          ),
          body: SingleChildScrollView(
            key: const Key('mainScroll'),
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                      child: BorderedTextField(
                          placeholder: 'Что нужно сделать?',
                          password: false,
                          controller: search,
                          iconName: Icons.search_sharp,
                          heightPadding: 17)),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 39, 0, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormat.format(selectDate),
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF002055)),
                        ),
                        Text(
                          '${widget.totalCount(ref) ?? 0} задач на сегодня',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF848A94)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 100,
                  child: AnimatedList(
                      // physics: const NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      initialItemCount: list.length,
                      itemBuilder:
                          (context, index, Animation<double> animation) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectDate =
                                  date.add(Duration(days: list[index]));
                            });
                          },
                          child: DateText(
                              days: list[index],
                              selectDate: selectDate,
                              date: date,
                              dayFormat: dayFormat),
                        );
                      }),
                ),
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
              ],
            ),
          ));
    });
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

mixin class HomeState {
  AsyncValue<TasksModel> tasks(WidgetRef ref) => ref.watch(getTasksProvider);
  int? totalCount(WidgetRef ref) => ref.read(getTasksProvider).value?.total;
}
