import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/helps_view/BorderedTextField.dart';

// ignore: must_be_immutable
class SectionTextfield extends ConsumerWidget {
  SectionTextfield(
      {super.key, required this.controller, this.header, this.placeholder});
  String? header = '';
  String? placeholder = '';
  TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 24, 16),
            child: Text(
              header ?? '',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF848A94)),
            )),
        BorderedTextField(
            placeholder: placeholder ?? '',
            password: false,
            controller: controller),
      ],
    );
  }
}
