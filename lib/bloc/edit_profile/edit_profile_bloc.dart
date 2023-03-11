import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  File? file;

  EditProfileBloc() : super(EditProfileInitial()) {
    Stream<DocumentSnapshot> stream;
    on<EditProfileEvent>((event, emit) async {

      if (event is ImagePickerEvent) {
        try {
          final xfile =
              await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50);
          if (xfile == null) return;
          File img = File(xfile.path);
          file = img;
          emit(AddPhoto(file: file!));
        } on PlatformException catch (e) {
          print(e);
          Navigator.pop(event.context);
        }
      }
      if (event is UpdateProfileInfoEvent) {

        try {
          emit(UpdateStateLoading());
//////////delete the previous image
          final info = await FirebaseFirestore.instance
              .collection('UsersData').doc(
              FirebaseAuth.instance.currentUser!.uid).get();
          Map? data = info.data();

          String profileUrl = data!['profileUrl'];

          FirebaseStorage.instance.refFromURL(profileUrl).delete();

         ///////////////create the new image in storage and get the link

          String uniqueImageName = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();

          Reference ref = FirebaseStorage.instance.ref()
              .child('UsersImages')
              .child(uniqueImageName);

          await ref.putFile(File(file!.path));

          String imgUrl = await ref.getDownloadURL();

          ///////////////update user info
          FirebaseFirestore.instance
              .collection('UsersData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'profileUrl': imgUrl,
            'name': event.name,
            'email': event.email,
            'phoneNumber': event.phoneNumber,
            'address': event.address,
            'gender': event.gender
          });


          ////update user email in auth
          await FirebaseAuth.instance.currentUser!.updateEmail(event.email);

          emit(UpdateStateSuccess());
        }
        catch (e){
          emit(UpdateStateError());
          print(e.toString());
        }

      }
    });
  }
}
