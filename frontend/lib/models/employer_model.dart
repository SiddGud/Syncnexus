import 'package:worker_app/models/user_model.dart';

class Employer extends User {
  Employer({required name, required phone, required email, required this.id})
      : super(email: email, name: name, phone: phone);

  final String id;
}
