import 'dart:convert';

import "package:http/http.dart" as http;

import 'base_endpoints.dart';

Future<bool> checkUser() async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/check-user/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 404) {
    return false;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> createUserOnBackend(
    {required String phoneNo,
    required String email,
    required String name,
    required String userType,
    required String firebaseUserId}) async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/create-user/');
  final requestData = {
    "phone_no": phoneNo,
    "name": name,
    "user_type": userType,
    "firebase_user_id": firebaseUserId,
    "email": email
  };
  Map<String, String> header = await headers();
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  print(response.statusCode);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 417 || response.statusCode == 409) {
    return false;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getUser() async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/get-user/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> addRating(String userTo, int rate, String comment) async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/$userTo/add-rating/');
  final requestData = {"rate": rate, "comment": comment};
  Map<String, String> header = await headers();
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  print(response.statusCode);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 500) {
    return false;
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<dynamic> getRating(String userID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/$userID/get-rating/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<List<dynamic>> getPayments(DateTime startTime, DateTime endTime) async {
  startTime = startTime.toUtc();
  endTime = endTime.toUtc();
  final requestData = {
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String()
  };
  final Uri uri = Uri.parse('${getBaseURL()}/user/get-payments/');
  Map<String, String> header = await headers();
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

Future<bool> addFeedback(int rating, String feedback) async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/add-feedback/');
  final requestData = {"rate": rating, "comment": feedback};
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

Future<dynamic> getUserByID(String userID) async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/$userID/fetch-user-by-id/');
  Map<String, String> header = await headers();
  final response = await http.get(uri, headers: header);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load data from endpoint: ${response.statusCode} ${response.body}');
  }
}

Future<bool> updateUser(String name, String phone, String email) async {
  final Uri uri = Uri.parse('${getBaseURL()}/user/update-user/');
  final requestData = {};
  if (name != "") {
    requestData["name"] = name;
  }
  if (phone != "") {
    requestData["phone_no"] = phone;
  }
  if (email != "") {
    requestData["email"] = email;
  }
  if (requestData.isEmpty) {
    return false;
  }
  Map<String, String> header = await headers();
  final response =
      await http.post(uri, headers: header, body: jsonEncode(requestData));
  if (response.statusCode == 200) {
    return true;
  } else {
    print(response.body);
    return false;
  }
}
