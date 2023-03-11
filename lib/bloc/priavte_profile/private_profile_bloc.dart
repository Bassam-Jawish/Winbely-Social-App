import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'private_profile_event.dart';
part 'private_profile_state.dart';

class PrivateProfileBloc extends Bloc<PrivateProfileEvent, PrivateProfileState> {

  PrivateProfileBloc() : super(PrivateProfileInitial()) {
    Stream<DocumentSnapshot> stream;
    on<PrivateProfileEvent>((event, emit) {
      if (event is DownloadPrivateProfileEvent) {
       try{ emit(PersonalInfoLoading());
         //stream = FirebaseFirestore.instance.collection('UsersData').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();

       stream = FirebaseFirestore.instance.collection('UsersData').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();

       emit(PersonalInfoSuccess(stream: stream));
      }
      catch (e){
         emit(PersonalInfoError());
         print(e.toString());
      }
      }
    });
  }
}
