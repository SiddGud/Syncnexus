import 'dart:convert';

import "package:http/http.dart" as http;

import 'base_endpoints.dart';

Future<bool> addTask(String employeeID, String heading, String description,
    DateTime lastDate) async {
  lastDate = lastDate.toUtc();
  final Uri uri = Uri.parse('${getBaseURL()}/employer/add-task/');
  final requestData = {
    "employee_id": employeeID,
    "heading": heading,
    "description": description,
    "last_date": lastDate.toIso8601String()
  };
  Map<String, String> header = await headers();
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    return false;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> addEmployee(String employeeID, String title) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$employeeID/add-employee/$title');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 406) {
    return false;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getEmployees() async {
  final Uri uri = Uri.parse('${getBaseURL()}/employer/get-employees/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getEmployee(String employeeID) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$employeeID/get-employee/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 404) {
    return {};
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getLocation(
  String employeeID,
  DateTime startTime,
  DateTime endTime,
) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$employeeID/get-employee-location/');
  Map<String, String> header = await headers();
  startTime = startTime.toUtc();
  endTime = endTime.toUtc();
  final requestData = {
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String()
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

Future<dynamic> searchByPhone(String PhoneNo) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$PhoneNo/search-employee-phone/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {};
  }
}

Future<dynamic> searchByEmail(String email) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$email/search-employee-email/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {};
  }
}

Future<bool> addJobs(String description, String title, double latitude,
    double longitude, int amount) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employer/add-jobs/');
  Map<String, String> header = await headers();
  final requestData = {
    "description": description,
    "title": title,
    "location_lat": latitude,
    "location_long": longitude,
    "amount": amount
  };
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> removeEmployee(String employeeID) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$employeeID/remove-employee/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> deleteTask(String taskID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employer/$taskID/delete-task/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> deleteJob(String jobID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employer/$jobID/delete-job/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> completeJob(String jobID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/employer/$jobID/complete-job/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> addPayments(
    String employeeID, String remarks, String currency, int amount) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$employeeID/add-payment/');
  Map<String, String> header = await headers();
  final requestData = {
    "remarks": remarks,
    "currency": currency,
    "amount": amount
  };
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getEmployeePayments(String employeeID) async {
  final Uri uri =
      Uri.parse('${getBaseURL()}/employer/$employeeID/get-payment/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getPostedJobs() async {
  final Uri uri = Uri.parse('${getBaseURL()}/employer/get-jobs/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}
