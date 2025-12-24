import 'package:intl/intl.dart';

enum TaskStatus { pending, completed, deleted }

class WorkerTask {
  WorkerTask(
      {required this.taskId,
      required this.desc,
      required this.task,
      required this.deadline,
      this.status = TaskStatus.pending}) {
    deadline = formatDate(deadline);
  }

  final String taskId;
  final String task;
  final String desc;
  String deadline;
  TaskStatus status;

  String formatDate(String deadline) {
    DateFormat dateFormat = DateFormat('dd MMM, E');
    return dateFormat.format(DateTime.parse(deadline)).toString();
  }
}
