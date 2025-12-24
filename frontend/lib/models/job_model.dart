import 'package:worker_app/models/employer_model.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:worker_app/models/lat_long_model.dart';

class Job {
  Job(
      {required this.jobId,
      required this.title,
      required this.desc,
      required this.employer,
      required this.amount,
      this.latLong,
      this.done,
      this.doneAt,
      this.deleted});

  final String jobId;
  final String title;
  final String desc;
  final Employer employer;
  final String amount;
  LatLong? latLong;
  bool? done;
  String? doneAt;
  bool? deleted;

  Future<void> removeThisJob() async {
    await deleteJob(jobId);
    deleted = true;
  }

  Future<void> completeThisJob() async {
    await completeJob(jobId);
    done = true;
  }
}
