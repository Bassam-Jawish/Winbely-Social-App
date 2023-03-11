import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'follow_helper_event.dart';
part 'follow_helper_state.dart';

class FollowHelperBloc extends Bloc<FollowHelperEvent, FollowHelperState> {
  FollowHelperBloc() : super(FollowHelperInitial()) {
    on<FollowHelperEvent>((event, emit) async {
      if (event is FollowEvent) {
        try {
          emit(FollowLoadingState());

          //update me I'm follow
          final Meinfo = await FirebaseFirestore.instance
              .collection('UsersData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
          Map? dataMe = Meinfo.data();

          int following = dataMe!['following'];

          FirebaseFirestore.instance
              .collection('UsersData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'following': following + 1,
          });

//update the user that I'm following
          final Userinfo = await FirebaseFirestore.instance
              .collection('UsersData')
              .doc(event.followUserId)
              .get();
          Map? dataUser = Userinfo.data();

          int followers = dataUser!['followers'];

          FirebaseFirestore.instance
              .collection('UsersData')
              .doc(event.followUserId)
              .update({
            'followers': followers + 1,
          });

          emit(FollowLSuccessState());
        } catch (e) {
          emit(FollowErrorState());
          print(e.toString());
        }
      }

      if (event is UnfollowEvent) {
        try {
          emit(UnfollowLoadingState());

          //update me I'm unfollow
          final Meinfo = await FirebaseFirestore.instance
              .collection('UsersData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
          Map? dataMe = Meinfo.data();

          int following = dataMe!['following'];

          FirebaseFirestore.instance
              .collection('UsersData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'following': following - 1});

//update the user that I'm unfollowing
          final Userinfo = await FirebaseFirestore.instance
              .collection('UsersData')
              .doc(event.unfollowUserId)
              .get();
          Map? dataUser = Userinfo.data();

          int followers = dataUser!['followers'];

          FirebaseFirestore.instance
              .collection('UsersData')
              .doc(event.unfollowUserId)
              .update({
            'followers': followers - 1,
          });

          emit(UnfollowLSuccessState());
        } catch (e) {
          emit(UnfollowErrorState());
          print(e.toString());
        }
      }
    });
  }
}
