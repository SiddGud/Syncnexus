part of 'tasks_cubit.dart';

abstract class EmployeeTasksState {}

final class EmployeeTasksLoading extends EmployeeTasksState {}

final class EmployeeTasksLoaded extends EmployeeTasksState {}

final class EmployeeNoTasksAvailable extends EmployeeTasksState {}
