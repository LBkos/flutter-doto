import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/widgets/tasks/create_task.dart';

typedef DateCallback = void Function(DateTime val);

// ignore: must_be_immutable
class DatePickerButton extends ConsumerStatefulWidget {
  DatePickerButton(
      {super.key, required this.selectedDate, this.text, this.end});
  bool? end = false;
  DateTime selectedDate = DateTime.now();
  String? text = '';
  // DateCallback callback;
  @override
  ConsumerState createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePickerButton> {
  Future<void> _selectDate(BuildContext context) async {
    final createTask = ref.watch(createTaskProvider);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: createTask.startDate,
        firstDate: DateTime(
            (widget.end == true) ? createTask.startDate.year : 2015,
            (widget.end == true) ? createTask.startDate.month : 8,
            (widget.end == true) ? createTask.startDate.day : 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        if (widget.end == true) {
          createTask.endDate = picked;
        } else {
          createTask.startDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.read(createTaskProvider);
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 24, 16),
              child: Text(
                widget.text ?? 'Дата',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF848A94)),
              )),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0xFFE9F1FF)),
                borderRadius: BorderRadius.circular(16)),
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: SizedBox(
                height: 54,
                child: Center(
                  child: Text(
                    DateFormat('dd.MM.yyyy', 'ru').format(
                        widget.end == true ? date.endDate : date.startDate),
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF002055)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
