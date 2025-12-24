import 'package:bloc/bloc.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/employer_model.dart';
import 'package:worker_app/models/job_model.dart';
import 'package:worker_app/models/worker_task_model.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:worker_app/provider/user_endpoints.dart';

part 'data_state.dart';

class EmployerDataCubit extends Cubit<EmployerDataState> {
  EmployerDataCubit() : super(EmployerDataLoading()) {
    getAllData();
  }

  late Employer employer;
  List<Employee> employeesList = [];
  List<Job> jobsList = [];
  List<WorkerTask> tasks = [];

  void getAllData() async {
    await getEmployersData();
    await getAllEmployees(listRemoved: false);
    await getAllJobs();
    emit(EmployerDataLoaded());
  }

  Future<void> getEmployersData() async {
    final data = await getUser();

    employer = Employer(
        name: data['name'],
        phone: data['phone_no'],
        email: data['email'],
        id: data['id']);
  }

  Future<void> getAllEmployees({bool listRemoved = false}) async {
    await getEmployees().then((employeesListUnparsed) {
      for (var employee in employeesListUnparsed) {
        if (!listRemoved && employee['status'] == 'removed') {
          continue;
        }

        employeesList.add(
          Employee(
              name: employee['name'],
              phone: employee['phone_no'],
              email: employee['email'],
              id: employee['employee_id'],
              removed: employee['status'] == 'removed'),
        );
      }
    });
  }

  Future<void> getAllJobs({bool shoudEmit = false}) async {
    final List<Job> allJobs = [];
    final rawJobs = await getPostedJobs();
    for (final rawJob in rawJobs) {
      if (rawJob['deleted'].toString().toLowerCase() != 'null') {
        continue;
      }

      Job job = Job(
        jobId: rawJob['id'],
        title: rawJob['title'],
        desc: rawJob['description'],
        employer: employer,
        amount: rawJob['amount'].toString(),
        done: rawJob['done'].toString().toLowerCase() == "null"
            ? null
            : true, // stores bool
        doneAt: rawJob['done'].toString().toLowerCase() == "null"
            ? null
            : rawJob['done'], // store date given in rawJob['done]
      );

      allJobs.add(job);
    }

    jobsList = allJobs;
    if (shoudEmit) {
      emit(EmployerDataLoaded());
    }
  }

  Future<void> freeEmployee(Employee employee) async {
    await removeEmployee(employee.id);
    employeesList.remove(employee);
    emit(EmployerDataLoaded());
  }

  Future<void> bindEmployee(Employee employee) async {
    await addEmployee(employee.id, "_");
    employeesList.add(employee);
    emit(EmployerDataLoaded());
  }

  void getAllTasks() async {}
}
