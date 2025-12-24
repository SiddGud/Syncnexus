part of 'data_cubit.dart';

abstract class EmployerDataState {}

final class EmployerDataLoading extends EmployerDataState {
  EmployerDataLoading();
}

final class EmployerDataLoaded extends EmployerDataState {
  EmployerDataLoaded();
}
