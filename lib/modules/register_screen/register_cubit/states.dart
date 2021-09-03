import 'package:social/models/user_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class ChangePasswordState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

class UserCreateLoadingState extends RegisterStates {}

class UserCreateSuccessState extends RegisterStates {
  final UserModel model;

  UserCreateSuccessState(this.model);
}

class UserCreateErrorState extends RegisterStates {
  final String error;

  UserCreateErrorState(this.error);
}
