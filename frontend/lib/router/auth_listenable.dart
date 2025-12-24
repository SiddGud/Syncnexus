import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:worker_app/provider/user_endpoints.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  needToFinishSignup,
  waiting,
}

class AuthListen extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late final StreamSubscription<dynamic> subscription;
  User? userx;

  AuthenticationStatus status = AuthenticationStatus.waiting;
  late bool isEmployee;

  AuthListen() {
    notifyListeners();
    listenToFirebaseAuth();
  }

  void listenToFirebaseAuth() async {
    subscription = firebaseAuth.authStateChanges().listen((user) async {
      if (user != null) {
        bool existOnBackend = await checkUser();

        if (existOnBackend) {
          final backendUser = await getUser();

          isEmployee = backendUser['user_type'] == 'employee' ? true : false;

          status = AuthenticationStatus.authenticated;
        } else {
          status = AuthenticationStatus.needToFinishSignup;
        }
      } else {
        status = AuthenticationStatus.unauthenticated;
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }
}
