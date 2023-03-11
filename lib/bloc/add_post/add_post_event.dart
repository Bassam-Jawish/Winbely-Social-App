part of 'add_post_bloc.dart';


abstract class AddPostEvent {}

class ImagePickerEvent extends AddPostEvent {
  final BuildContext context;

  ImagePickerEvent({required this.context});
}

class UploadPostEvent extends AddPostEvent {

  final File file;
  final String desc;

  UploadPostEvent({required this.file,required this.desc});

}
