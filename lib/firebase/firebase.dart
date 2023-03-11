import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firebase_helper {
  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  static Future<UserCredential> signup(
      {required String name,
      required String email,
      required String password,
      required String phoneNumber,
      required int gender}) async {
    return
         await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
/*
    if (userCredential != null) {
      FirebaseFirestore.instance
          .collection('User Data')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'gender': gender
      });
    }*/
  }

  static Future<UserCredential> LoginWithEmailAndPassword(
      {required String email, required String password}) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
