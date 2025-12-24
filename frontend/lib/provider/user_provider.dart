import 'package:flutter/material.dart';
import 'package:worker_app/provider/user_endpoints.dart';

class UserProvider extends ChangeNotifier {
  UserProvider();

  late final String uid;

  late String name;
  late String phone;
  late String email;
  late bool employee;

  Future<bool> createUser() async {
    return await createUserOnBackend(
        phoneNo: phone,
        name: name,
        email: email,
        userType: employee ? "employee" : "employer",
        firebaseUserId: uid);
  }

  void updateUser() async {}
}
