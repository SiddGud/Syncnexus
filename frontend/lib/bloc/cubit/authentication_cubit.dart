import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(Authenticated()) {
    getAuthenticationState();
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void getAuthenticationState() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(Authenticated());
  }
}
