// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class BorderedTextField extends ConsumerStatefulWidget {
  BorderedTextField(
      {super.key,
      required this.placeholder,
      required this.password,
      required TextEditingController controller,
      this.heightPadding = 20,
      this.iconName})
      : textController = controller;
  final String placeholder;
  final bool password;
  final IconData? iconName;
  double heightPadding = 20;
  TextEditingController textController;

  @override
  // ignore: library_private_types_in_public_api
  _BorderedTextField createState() => _BorderedTextField();
}

class _BorderedTextField extends ConsumerState<BorderedTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
      autocorrect: false,
      obscureText: widget.password,
      controller: widget.textController,
      onChanged: (value) {},
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE9F1FF)),
            borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF756EF3)),
            borderRadius: BorderRadius.circular(16)),
        hintText: widget.placeholder,
        hintStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: const Color(0x7F002055)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        prefixIcon: (widget.iconName != null)
            ? const Image(image: AssetImage('images/search.png'))
            : null,
        contentPadding: EdgeInsets.all(widget.heightPadding),
      ),
    );
  }
}
