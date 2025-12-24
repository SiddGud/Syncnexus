part of 'data_cubit.dart';

abstract class EmployeeDataState {}

final class EmployeeDataLoading extends EmployeeDataState {
  EmployeeDataLoading();
}

final class EmployeeDataLoaded extends EmployeeDataState {
  EmployeeDataLoaded();
}
