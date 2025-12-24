import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

String getBaseURL() {
  return "https://google-solution-challenge-backend-jpnacpp5ta-em.a.run.app";
  //return "http://0.0.0.0:80";
  //return "https://test-google-solution-challenge-backend-jpnacpp5ta-em.a.run.app";
}

Future<Map<String, String>> headers() async {
  late final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? idToken = await firebaseAuth.currentUser!.getIdToken();
  //String idToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUzZWFiMDBhNzc5MTk3Yzc0MWQ2NjJmY2EzODE1OGJkN2JlNGEyY2MiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc29sdXRpb24tY2hhbGxlbmdlLWNhNTU0IiwiYXVkIjoic29sdXRpb24tY2hhbGxlbmdlLWNhNTU0IiwiYXV0aF90aW1lIjoxNzA3NTUyNTc1LCJ1c2VyX2lkIjoidlEwTE5JcUJaR2ZUWDZUdG95NklOclNpTmxjMiIsInN1YiI6InZRMExOSXFCWkdmVFg2VHRveTZJTnJTaU5sYzIiLCJpYXQiOjE3MDc1NTI1NzUsImV4cCI6MTcwNzU1NjE3NSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6e30sInNpZ25faW5fcHJvdmlkZXIiOiJjdXN0b20ifX0.Ek-bxF1Cp1B_6waa8S5-rhkoiag9BSxtXtpjwY3rFz4CNkqyvGxhYxg1P3lGdszw6zxcq5pjucXAg8yNRBQaGz3WKaan4vk1MORqk8e_aC1W88np8LN_hBzqdrCmOQ9nojSmHLHV5oxZ0IjzOc_jnit0XyFVNJOMCReRxC-4VO7JnkMml6N9marX1ZS7-3_VJdtZbUpmlQyXfBtzK_P6w6P96vF39Z53KI1yAuxrYFUQ8Sro5NK81kFBhsDQEibaPLRn-rZiD0hrcCmHoza2CdzWty2OdvxL_cmVyNShB3Jy4pedb3qV0cKrRhWkiikkTqEd8OBqf3ZDDo_g3dH6JA";
  return {
    "Authorization": "Bearer $idToken",
    'Content-Type': 'application/json'
  };
}
