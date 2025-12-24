import 'package:flutter/material.dart';
import 'package:worker_app/models/user_model.dart';
import 'package:worker_app/models/worker_task_model.dart';
import 'package:worker_app/provider/employee_endpoints.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:worker_app/models/lat_long_model.dart';
import 'package:worker_app/provider/user_endpoints.dart';

class Employee extends User with ChangeNotifier {
  Employee(
      {required name,
      required phone,
      required email,
      required this.id,
      this.removed = false})
      : super(email: email, name: name, phone: phone) {
    getMyTasks();
    getLastRecordedLocation();
  }

  final String id;
  List<WorkerTask> tasks = [];
  List<WorkerTask> allTasks = [];
  bool removed;
  String? rating;
  LatLongCollection locationRecords = LatLongCollection();

  Future<void> getMyTasks() async {
    final List<WorkerTask> pendingTasks = [];
    final List<WorkerTask> allParsedTasks = [];

    try {
      final unparsedTasks =
          await getTasks(id, DateTime.parse("2000-01-01"), DateTime.now());

      for (final task in unparsedTasks) {
        final String taskId = task['id'];
        final String heading = task['heading'];
        final String deadline = task['last_date'];
        final String stringStatus = task['status'];
        final String description = task['description'];
        late final TaskStatus status;

        if (stringStatus == 'pending') {
          status = TaskStatus.pending;
        } else if (stringStatus == 'done') {
          status = TaskStatus.completed;
        } else {
          status = TaskStatus.deleted;
        }

        WorkerTask parsedTask = WorkerTask(
            taskId: taskId,
            task: heading,
            deadline: deadline,
            status: status,
            desc: description);

        if (status == TaskStatus.pending) {
          pendingTasks.add(parsedTask);
        }

        allParsedTasks.add(parsedTask);
      }

      tasks = pendingTasks;
      allTasks = allParsedTasks;

      notifyListeners();
    } catch (e) {
      removed = true;
      return;
    }
  }

  Future<void> getLastRecordedLocation() async {
    final latLongCollectionUnparsed =
        await getLocation(id, DateTime.parse("2000-01-01"), DateTime.now());

    for (final rawLatLong in latLongCollectionUnparsed) {
      final lat = rawLatLong['location_lat'];
      final long = rawLatLong['location_long'];
      final DateTime createdAt = DateTime.parse(rawLatLong['created_at']);

      LatLong latLong = LatLong(lat: lat, long: long, createdAt: createdAt);

      locationRecords.add(latLong);
    }
  }

  Future<void> completeThisTask(WorkerTask task) async {
    await completeTask(task.taskId);
    tasks.remove(task);
    notifyListeners();
  }

  Future<void> removeThisTask(WorkerTask task) async {
    await deleteTask(task.taskId);
    tasks.remove(task);
    allTasks.remove(task);
    notifyListeners();
  }

  Future<void> getMyRating() async {
    try {
      rating = (await getRating(id))['rate'].toString();
    } catch (e) {
      rating = '0';
    }
  }
}
