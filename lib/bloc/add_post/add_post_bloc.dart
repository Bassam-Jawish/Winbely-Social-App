import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_post_event.dart';

part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  File? file;

  AddPostBloc() : super(AddPostInitial()) {
    on<AddPostEvent>((event, emit) async {
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

      if (event is UploadPostEvent) {

        try {

          emit(AddPostLoading());

          String postId = Uuid().v4();

          //store post img
          Reference ref = FirebaseStorage.instance.ref().child('Posts').child(
              'post_$postId.img');

          /*Reference ref = FirebaseStorage.instance.ref().child('Posts').child(
              'post_$postId.vid');*/

          await ref.putFile(File(event.file!.path));

          String imgUrl = await ref.getDownloadURL();

          ////////////////////////////////////////fetch userinfo
          final info = await FirebaseFirestore.instance
              .collection('UsersData').doc(
              FirebaseAuth.instance.currentUser!.uid).get();
          Map? data = info.data();
          String name = data!['name'];
          String profileUrl = data!['profileUrl'];
          Map <String,dynamic> posts = data!['posts'];
          posts!.addAll({postId: imgUrl});

          int postsNumber = data['postsNumber'];

          //store to posts home
          FirebaseFirestore.instance
              .collection('PostsData')
              .doc(postId)
              .set({
            'postUrl': imgUrl,
            'description': event.desc,
            'postId': postId,
            'name': name,
            'profileUrl': profileUrl,
            'time': DateTime.now(),
          });

          //update user info
          FirebaseFirestore.instance
              .collection('UsersData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'posts': posts,
            'postsNumber': postsNumber + 1
          });
          emit(AddPostSuccess());
        }
        catch(e){
          emit(AddPostError(loginErrorMessage:e.toString()));
          print(e.toString());
        }

      }
    });
  }
}
