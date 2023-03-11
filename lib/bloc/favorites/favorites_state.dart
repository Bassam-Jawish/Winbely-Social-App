part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class addFavoritesLoading extends FavoritesState {}

class addFavoritesSuccess extends FavoritesState {}

class addFavoritesError extends FavoritesState {}


 class GetFavoritesPostsLoading extends FavoritesState {}

class GetFavoritesPostsSuccess extends FavoritesState {
  Stream stream;

  GetFavoritesPostsSuccess({required this.stream});

}

class GetFavoritesPostsError extends FavoritesState {}
