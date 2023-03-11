import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {


  FavoritesBloc() : super(FavoritesInitial()) {
    Stream stream;
    on<FavoritesEvent>((event, emit) async {
      if (event is addFavoritesEvent) {
        try {
          emit(addFavoritesLoading());

          FirebaseFirestore.instance
              .collection('FavoritesData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('UserFavorites')
              .doc(event.postId)
              .set({
            'postUrl': event.imgUrl,
            'description': event.desc,
            'postId': event.postId,
            'name': event.name,
            'profileUrl': event.profileUrl,
            'time': event.time,
          });

          emit(addFavoritesSuccess());
        } catch (e) {
          emit(addFavoritesError());
          print(e.toString());
        }
      }
      if (event is GetFavoritesPostsEvent) {

        try {
          emit(GetFavoritesPostsLoading());

          stream = await FirebaseFirestore.instance
              .collection('FavoritesData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('UserFavorites')
              .orderBy('time', descending: true)
              .snapshots();

          emit(GetFavoritesPostsSuccess(stream: stream));
        }
        catch (e){
          emit(GetFavoritesPostsError());
          print(e.toString());
        }
      }
    });
  }
}
