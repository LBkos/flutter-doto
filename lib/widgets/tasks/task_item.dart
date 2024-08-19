import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/providers/tasks_provider.dart';

// ignore: must_be_immutable
class TaskItem extends ConsumerStatefulWidget {
  const TaskItem({super.key, this.index});
  final index;

  @override
  // ignore: library_private_types_in_public_api
  _TaskState createState() => _TaskState();
}

class _TaskState extends ConsumerState<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosNotifierProvider);
    return ListTile(
      // dense: true,
      // contentPadding: const EdgeInsets.fromLTRB(5, 0, 16, 0),
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(12)),
      // ),
      trailing: Icon(
        Icons.info_outline,
        color: Colors.green[300],
      ),
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      leading: Transform.scale(
        scale: 1,
        child: Checkbox(
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (!states.contains(WidgetState.selected)) {
                return Colors.transparent;
              }
              return null;
            }),
            side: const BorderSide(color: Color(0xFF002055), width: 1.13),
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1.13, color: Color(0xFF002055)),
                borderRadius: BorderRadius.circular(4)),
            activeColor: const Color(0xFFB1D199),
            checkColor: const Color(0xFF002055),
            // materialTapTargetSize: MaterialTapTargetSize.padded,
            value: todos[widget.index].isDone,
            onChanged: (bool? value) => {
                  ref
                      .watch(todosNotifierProvider.notifier)
                      .toggle(todos[widget.index].sid)
                }),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todos[widget.index].title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF002055),
                decoration: todos[widget.index].isDone
                    ? TextDecoration.lineThrough
                    : null),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: FaIcon(
                  FontAwesomeIcons.tag,
                  size: 10,
                  color: Color(0xFF756EF3),
                ),
              ),
              Text(
                '${todos[widget.index].tag.name} ',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF848A94)),
              ),
              Text(
                DateFormat('dd MMMM HH:mm', 'ru')
                    .format(todos[widget.index].finishAt),
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: DateTime.now().isBefore(todos[widget.index].finishAt)
                        ? Colors.black54
                        : Colors.red[200]),
              )
            ],
          ),
        ],
      ),
    );
    // ListTileTheme(
    //     data: ListTileThemeData(
    //         // tileColor: Colors.redAccent,
    //         // titleAlignment: ListTileTitleAlignment.top,
    //         // contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    //         minVerticalPadding: 0,
    //         horizontalTitleGap: 0),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Checkbox(
    //             // materialTapTargetSize: MaterialTapTargetSize.padded,
    //             value: isChecked,
    //             onChanged: (bool? value) => {
    //                   setState(() {
    //                     isChecked = value!;
    //                   }),
    //                 }),
    //         Column(
    //           children: [
    //             Text(widget.task.title),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const Padding(
    //                   padding: EdgeInsets.only(right: 5),
    //                   child: FaIcon(
    //                     FontAwesomeIcons.tag,
    //                     size: 10,
    //                     color: Color(0xFF756EF3),
    //                   ),
    //                 ),
    //                 Text(
    //                   widget.task.tag.name,
    //                   style: GoogleFonts.poppins(
    //                       fontSize: 13,
    //                       fontWeight: FontWeight.w400,
    //                       color: const Color(0xFF848A94)),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         )
    //       ],
    //     ));
  }
}
