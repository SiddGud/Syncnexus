part of 'authentication_cubit.dart';

abstract class AuthenticationState {}

final class AuthenticationWaiting extends AuthenticationState {}

final class Authenticated extends AuthenticationState {}

final class Unautheticated extends AuthenticationState {}
