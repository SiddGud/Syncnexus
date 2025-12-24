import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worker_app/models/worker_task_model.dart';

class TaskWidgetEmployer extends StatefulWidget {
  const TaskWidgetEmployer({super.key, required this.task, required this.fxn});

  final WorkerTask task;
  final Function fxn;

  @override
  State<TaskWidgetEmployer> createState() => _TaskWidgetEmployerState();
}

class _TaskWidgetEmployerState extends State<TaskWidgetEmployer> {
  void removeTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete this task",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure, you want to delte this task?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 226, 181, 31),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    ).then((result) async {
      widget.fxn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.grey.shade200,
        surfaceTintColor: Colors.transparent,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            title: Text(
              widget.task.task,
              style: GoogleFonts.urbanist(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: RichText(
              text: TextSpan(
                  text: "Deadline: ",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  children: const [
                    TextSpan(
                      text: "23 Jan, 1PM",
                    )
                  ]),
            ),
            trailing: IconButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, shape: const CircleBorder()),
                onPressed: removeTask,
                icon: const Icon(Icons.remove)),
          )
        ]));
  }
}
