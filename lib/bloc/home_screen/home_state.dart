part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetPostsLoading extends HomeState {}

class GetPostsSuccess extends HomeState {
  Stream stream;

  GetPostsSuccess({required this.stream});

}

class GetPostsError extends HomeState {}