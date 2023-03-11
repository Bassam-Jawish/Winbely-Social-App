part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  String token;

  RegisterSuccess({required this.token});
}

class RegisterError extends AuthState {
  String registerErrorMessage;

  RegisterError({required this.registerErrorMessage});
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  String token;

  LoginSuccess({required this.token});
}

class LoginError extends AuthState {
  String loginErrorMessage;

  LoginError({required this.loginErrorMessage});
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutError extends AuthState {}


class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordError extends AuthState {
  final String errorMessage;

  ResetPasswordError({required this.errorMessage});

}
