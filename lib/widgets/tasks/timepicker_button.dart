import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/widgets/tasks/create_task.dart';

// ignore: must_be_immutable
class TimePickerButton extends ConsumerStatefulWidget with TaskEvent {
  TimePickerButton({super.key, this.text, this.end});
  bool? end = false;
  String? text = '';

  @override
  ConsumerState createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<TimePickerButton> {
  Future<void> _selectTime(BuildContext context) async {
    final createTask = ref.watch(createTaskProvider.notifier);
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        if (widget.end == true) {
          createTask.state.endTime = picked;
        } else {
          createTask.state.startTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final createTask = ref.read(createTaskProvider);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 24, 16),
              child: Text(
                widget.text ?? 'Время',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF848A94)),
              )),
          Container(
              decoration: BoxDecoration(
                  // shape: BoxShape.rectangle,
                  border: Border.all(width: 1, color: const Color(0xFFE9F1FF)),
                  borderRadius: BorderRadius.circular(16)),
              child: GestureDetector(
                onTap: () {
                  _selectTime(context);
                },
                child: SizedBox(
                  height: 54,
                  child: Center(
                    child: Text(
                      MaterialLocalizations.of(context).formatTimeOfDay(
                          widget.end == true
                              ? createTask.endTime
                              : createTask.startTime,
                          alwaysUse24HourFormat: true),
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF002055)),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
