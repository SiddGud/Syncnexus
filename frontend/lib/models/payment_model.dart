import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/employer_model.dart';

class Payment {
  Payment({
    required this.paymentId,
    required this.amount,
    required this.paidBy,
    required this.paidTo,
    required this.currency,
    required this.remarks,
    required this.createdAt,
    required this.approvedAt,
  });

  String paymentId;
  int amount;

  Employer paidBy;
  Employee paidTo;

  String currency;
  String remarks;

  String createdAt;
  String? approvedAt;
}
