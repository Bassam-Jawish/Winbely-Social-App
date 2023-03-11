part of 'private_profile_bloc.dart';

@immutable
abstract class PrivateProfileState {}

class PrivateProfileInitial extends PrivateProfileState {}

class PersonalInfoLoading extends PrivateProfileState {}

class PersonalInfoSuccess extends PrivateProfileState {
  Stream<DocumentSnapshot> stream;

  PersonalInfoSuccess({required this.stream});

}

class PersonalInfoError extends PrivateProfileState {}
