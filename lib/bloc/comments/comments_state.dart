part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class ShowCommentsLoading extends CommentsState {}

class ShowCommentsSuccess extends CommentsState {

  List result = [];

  ShowCommentsSuccess({required this.result});

}

class ShowCommentsError extends CommentsState {}

class AddCommentsLoading extends CommentsState {}

class AddCommentsSuccess extends CommentsState {}

class AddCommentsError extends CommentsState {}
