// centered_progress_view.dart
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CenteredProgressView extends ConsumerWidget {
  const CenteredProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF756EF3),
          ),
        ));
  }
}
