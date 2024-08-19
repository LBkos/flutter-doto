import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_manager/helps_view/custom_back_button.dart';
import 'package:task_manager/widgets/tasks/create_task_model.dart';
import 'package:task_manager/widgets/tasks/datepicker_button.dart';
import 'package:task_manager/widgets/tasks/section_textfield.dart';
import 'package:task_manager/widgets/tasks/timepicker_button.dart';

final createTaskProvider = (StateProvider<CreateTaskModel>((ref) {
  return CreateTaskModel();
}));

class CreateTask extends ConsumerStatefulWidget {
  const CreateTask({super.key});
  @override
  ConsumerState createState() => _CreateState();
}

class _CreateState extends ConsumerState<CreateTask> {
  @override
  Widget build(BuildContext context) {
    final createTask = ref.watch(createTaskProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text('Добавить задачу'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: SectionTextfield(
                  controller: createTask.state.taskNameController,
                  header: 'Наименование задачи',
                  placeholder: 'Наименование задачи',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: SectionTextfield(
                  controller: createTask.state.taskTextController,
                  header: 'Примечание',
                  placeholder: 'Текст примечания',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      DatePickerButton(
                          selectedDate: createTask.state.startDate),
                      const SizedBox(width: 31),
                      TimePickerButton(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        checkColor: const Color(0xFF002055),
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Color(0xFFB1D199);
                          }
                          return const Color(0xFFFFFFFF);
                        }),
                        value: createTask.state.isPresentedEnd,
                        onChanged: (bool? value) {
                          setState(() {
                            createTask.state.isPresentedEnd = value!;
                          });
                        }),
                    Text(
                      'Есть срок?',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF848A94)),
                    )
                  ],
                ),
              ),
              Container(
                child: createTask.state.isPresentedEnd
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(26, 0, 26, 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              DatePickerButton(
                                selectedDate: createTask.state.endDate,
                                text: 'Выполнить до',
                                end: true,
                              ),
                              const SizedBox(width: 31),
                              TimePickerButton(end: true),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
              Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.fromLTRB(70, 12, 70, 12)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                      foregroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFFFFFFF)),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF756EF3)),
                    ),
                    onPressed: () => {createTask.state.createTask(context)},
                    child: Text(
                      'Добавить',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    )),
              )
            ],
          ),
        ));
  }
}

mixin class TaskEvent {
  DateTime createdDate = DateTime.now();
  TimeOfDay createdTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime =
      TimeOfDay(hour: DateTime.now().hour + 1, minute: DateTime.now().minute);
}
