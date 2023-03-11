part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}



class AddPhoto extends EditProfileState {
  File file;

  AddPhoto({required this.file});
}



class UpdateStateLoading extends EditProfileState {}

class UpdateStateSuccess extends EditProfileState {}

class UpdateStateError extends EditProfileState {}
