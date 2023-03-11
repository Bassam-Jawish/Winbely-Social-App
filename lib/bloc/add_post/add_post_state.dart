part of 'add_post_bloc.dart';

@immutable
abstract class AddPostState {}

class AddPostInitial extends AddPostState {}

class AddPhoto extends AddPostState {
  File file;

  AddPhoto({required this.file});
}

class AddPostLoading extends AddPostState {}

class AddPostSuccess extends AddPostState {

}

class AddPostError extends AddPostState {
String loginErrorMessage;

AddPostError({required this.loginErrorMessage});
}