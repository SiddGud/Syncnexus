import 'package:flutter_bloc/flutter_bloc.dart';
part 'tasks_state.dart';

class EmployeeTasksCubit extends Cubit<EmployeeTasksState> {
  EmployeeTasksCubit() : super(EmployeeTasksLoading());

  void getTasks() {}
}
