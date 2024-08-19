// date_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DateText extends ConsumerWidget {
  DateText(
      {super.key,
      required this.days,
      required this.selectDate,
      required this.date,
      required this.dayFormat});
  final int days;
  final DateTime date;
  DateTime selectDate;
  final DateFormat dayFormat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
            width: 64,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9F1FF)),
              borderRadius: BorderRadius.circular(16),
              color: selectDate.compareTo(date.add(Duration(days: days))) == 0
                  ? const Color(0xFF756EF3)
                  : const Color.fromARGB(0, 255, 255, 255),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date
                          .add(
                            Duration(days: days),
                          )
                          .day
                          .toString(),
                      // key: ValueKey<DateTime>(selectDate),
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: (selectDate == date.add(Duration(days: days)))
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF848A94)),
                    ),
                    Text(
                      dayFormat.format(date.add(Duration(days: days))),
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (selectDate == date.add(Duration(days: days)))
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF848A94)),
                    ),
                  ],
                ))));
  }
}
