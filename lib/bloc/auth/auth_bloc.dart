import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>(
      (event, emit) async {
        if (event is LoginEvent) {
          emit(LoginLoading());
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: event.email, password: event.password);

            var userToken =
                await FirebaseAuth.instance.currentUser!.getIdToken();

            emit(LoginSuccess(token: userToken));
          } on FirebaseAuthException catch (ex) {
            if (ex.code == 'user-not-found') {
              print('No user found for that email.');
              emit(LoginError(loginErrorMessage: ex.code));
            } else if (ex.code == 'wrong-password') {
              emit(LoginError(loginErrorMessage: ex.code));
              print('Wrong password provided for that user.');
            } else if (ex.code == 'unknown') {
              emit(LoginError(loginErrorMessage: 'Bad Internet Connection'));
            }
          } catch (e) {
            print(e);
          }
        }

        if (event is RegisterEvent) {
          emit(RegisterLoading());
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

            //img
            String img = 'assets/images/user.png';

            String imageName =
                img.substring(img.lastIndexOf("/"), img.lastIndexOf("."));

            String path =
                img.substring(img.indexOf("/") + 1, img.lastIndexOf("/"));

            String uniqueImageName =
                DateTime.now().millisecondsSinceEpoch.toString();

            final Directory systemTempDir = Directory.systemTemp;
            final byteData = await rootBundle.load(img);
            final file = File('${systemTempDir.path}/$imageName.png');

            await file.writeAsBytes(byteData.buffer
                .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

////////////////////////////////////////////////////////

            Reference ref = FirebaseStorage.instance
                .ref()
                .child('UsersImages')
                .child(uniqueImageName);

            await ref.putFile(File(file.path));

            String imgUrl = await ref.getDownloadURL();

            //img

            FirebaseFirestore.instance
                .collection('UsersData')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({
              'userId': FirebaseAuth.instance.currentUser!.uid,
              'profileUrl': imgUrl,
              'name': event.name,
              'email': event.email,
              'phoneNumber': event.phoneNumber,
              'gender': event.gender,
              'address': 'Syria, Damascus',
              'followers': 0,
              'following': 0,
              'posts': {},
              'postsNumber': 0
            });

            var userToken =
                await FirebaseAuth.instance.currentUser!.getIdToken();

            emit(RegisterSuccess(token: userToken));
          } on FirebaseAuthException catch (ex) {
            if (ex.code == 'weak-password') {
              emit(RegisterError(registerErrorMessage: ex.code));
            } else if (ex.code == 'email-already-in-use') {
              emit(RegisterError(registerErrorMessage: ex.code));
            } else if (ex.code == 'unknown') {
              emit(RegisterError(
                  registerErrorMessage: 'Bad Internet Connection'));
            }
          } catch (e) {
            print(e);
          }
        }

        if (event is SignOutEvent) {
          try {
            emit(SignOutLoading());
            await FirebaseAuth.instance.signOut();
            emit(SignOutSuccess());
          } catch (err) {
            emit(SignOutError());
            print(err.toString());
          }
        }

        if (event is RestPasswordEvent) {
          try {
            emit(ResetPasswordLoading());

            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: event.email);

            emit(ResetPasswordSuccess());
          } on FirebaseAuthException catch (ex) {
            if (ex.code == 'weak-password') {
              emit(RegisterError(registerErrorMessage: ex.code));
            } else if (ex.code == 'email-already-in-use') {
              emit(RegisterError(registerErrorMessage: ex.code));
            } else if (ex.code == 'unknown') {
              emit(RegisterError(
                  registerErrorMessage: 'Bad Internet Connection'));
            } else {
              print(ex.code);
            }
          }
        }
      },
    );
  }
}
