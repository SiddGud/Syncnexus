import 'dart:convert';

import "package:http/http.dart" as http;

import 'base_endpoints.dart';

Future<bool> completeTask(String taskID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/$taskID/complete-task/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 409 || response.statusCode == 404) {
    return false;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getTask(String taskID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/$taskID/get-task/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getTasks(
    String employeeID, DateTime startTime, DateTime endTime) async {
  startTime = startTime.toUtc();
  endTime = endTime.toUtc();
  final requestData = {
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String()
  };
  final Uri uri = Uri.parse('${getBaseURL()}/employee/$employeeID/get-tasks/');
  Map<String, String> header = await headers();
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getJobDetail(String jobID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/$jobID/get-job-detail/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getEmployer() async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/get-employer/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> addLocation(double locationLat, double locationLong) async {
  final requestData = {
    "location_lat": locationLat,
    "location_long": locationLong
  };
  final Uri uri = Uri.parse('${getBaseURL()}/employee/add-location/');
  Map<String, String> header = await headers();
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getJobs(double locationLat, double locationLong) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/find-jobs/');
  Map<String, String> header = await headers();
  final requestData = {
    "location_lat": locationLat,
    "location_long": locationLong
  };
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> leaveJob() async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/leave-job/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> approvePayment(String paymentID) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employee/$paymentID/approve-payment/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getEmployeeJob() async {
  final Uri uri = Uri.parse('${getBaseURL()}/employee/get-employee-job/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}
