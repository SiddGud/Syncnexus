import 'package:bloc/bloc.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/employer_model.dart';
import 'package:worker_app/provider/employee_endpoints.dart';
import 'package:worker_app/provider/user_endpoints.dart';

part 'data_state.dart';

class EmployeeDataCubit extends Cubit<EmployeeDataState> {
  EmployeeDataCubit() : super(EmployeeDataLoading()) {
    getAllData();
  }

  late Employee employee;
  late Employer? employer;
  final Map<String, double> location = {
    'lat': 0,
    'long': 0,
  };

  Future<void> getEmployersData() async {
    try {
      final Map<dynamic, dynamic> data = await getEmployer();
      employer = Employer(
          name: data['name'],
          phone: data['phone_no'],
          email: data['email'],
          id: data['id']);
    } catch (e) {
      print(e);
      employer = null;
    }
  }

  void setLocation({required double lat, required double long}) {
    location['lat'] = lat;
    location['long'] = long;
  }

  Future<void> getEmployeeData() async {
    final data = await getUser();

    employee = Employee(
        name: data['name'],
        phone: data['phone_no'],
        email: data['email'],
        id: data['id']);
  }

  void getAllData() async {
    await getEmployeeData();
    await getEmployersData();
    await employee.getMyTasks();
    emit(EmployeeDataLoaded());
  }
}
