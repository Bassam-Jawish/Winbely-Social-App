import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String? id;
  final String? profileUrl;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  final int? gender;
  final String? Address;

  UserInfo({
    this.id,
    this.profileUrl,
    this.name,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.gender,
    this.Address,
  });

  factory UserInfo.fromDocument(DocumentSnapshot doc) {
    return UserInfo(
      id: doc['id'],
      profileUrl: doc['profileUrl'],
      name: doc['username'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
      Address: doc['Address'],
    );
  }
}
