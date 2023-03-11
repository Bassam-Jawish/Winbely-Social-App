part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final int gender;

  RegisterEvent(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.gender});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class SignOutEvent extends AuthEvent {}

class RestPasswordEvent extends AuthEvent {
  final String email;

  RestPasswordEvent({required this.email});
}
