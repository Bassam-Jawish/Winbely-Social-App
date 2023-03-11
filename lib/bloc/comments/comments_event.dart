part of 'comments_bloc.dart';

@immutable
abstract class CommentsEvent {}

class ShowCommentsEvent extends CommentsEvent {
}

class AddCommentsEvent extends CommentsEvent {
  final String comment;

  AddCommentsEvent({required this.comment});
}
