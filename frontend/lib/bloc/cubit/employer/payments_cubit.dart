import 'package:bloc/bloc.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/employer_model.dart';
import 'package:worker_app/models/payment_model.dart';
import 'package:worker_app/provider/user_endpoints.dart';
import 'package:intl/intl.dart';

part 'payments_state.dart';

class EmployerPaymentsCubit extends Cubit<EmployerPaymentsState> {
  EmployerPaymentsCubit() : super(EmployerPaymentsLoading()) {
    getAllPayments();
  }

  late List<Payment> payments;

  void getAllPayments() async {
    final List<Payment> allPayments = [];

    final rawPayments =
        await getPayments(DateTime.parse("2000-01-01"), DateTime.now());

    DateFormat dateFormat = DateFormat('MMMM dd, yyyy HH:MM');
    for (final rawPayment in rawPayments) {
      final String createdAt =
          dateFormat.format(DateTime.parse(rawPayment['created_at']));

      Employer employer = Employer(
          name: rawPayment['from_user']['name'],
          phone: rawPayment['from_user']['phone_no'],
          email: rawPayment['from_user']['email'],
          id: rawPayment['from_user']['id']);

      Employee employee = Employee(
          name: rawPayment['to_user']['name'],
          phone: rawPayment['to_user']['phone_no'],
          email: rawPayment['to_user']['email'],
          id: rawPayment['to_user']['id']);

      Payment payment = Payment(
          paymentId: rawPayment['id'],
          amount: rawPayment['amount'],
          paidBy: employer,
          paidTo: employee,
          currency: rawPayment['currency'],
          remarks: rawPayment['remarks'],
          createdAt: createdAt,
          approvedAt: rawPayment['approved_at']);

      allPayments.add(payment);
    }

    payments = allPayments;

    emit(EmployerPaymentsLoaded());
  }
}
