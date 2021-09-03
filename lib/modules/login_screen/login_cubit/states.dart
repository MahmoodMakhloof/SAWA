import 'package:social/models/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangePasswordState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uid;

  LoginSuccessState(this.uid);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}
