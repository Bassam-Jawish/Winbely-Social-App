part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class ImagePickerEvent extends EditProfileEvent {
  final BuildContext context;

  ImagePickerEvent({required this.context});
}

class UpdateProfileInfoEvent extends EditProfileEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final int gender;

  UpdateProfileInfoEvent(
      {required this.name,
        required this.email,
        required this.phoneNumber,
        required this.address,
        required this.gender});
}