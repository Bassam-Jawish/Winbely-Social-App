part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesEvent {}

class addFavoritesEvent extends FavoritesEvent {

  final String imgUrl;
  final String desc;
  final String postId;
  final String name;
  final String profileUrl;
  final String time;


  addFavoritesEvent({required this.imgUrl,required this.desc,required this.postId,required this.name,required this.profileUrl,required this.time});
}

class GetFavoritesPostsEvent extends FavoritesEvent {}
