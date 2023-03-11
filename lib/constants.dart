import 'package:chat_app/cache/cache_helper.dart';
import 'package:chat_app/ui/screens/login.dart';
import 'package:flutter/material.dart';

void signOut(context)
{
  CacheHelper.signOut(key: 'token').then((value)
  {
    if(value)
    {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>  LoginScreen(),),
              (route) => false);
    }
  });
}

String? token = '';
Widget? startwidget;
bool? onBoarding;

//Chat
String? peerId;
String? peerName;
String? peerProfileUrl;

//Comment
String? commentPostId;
String? commentProfileUrl;
String? commentName;
String? commentDesc;
String? commentTime;