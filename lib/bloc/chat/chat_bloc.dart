import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List usersResult = [];

  ChatBloc() : super(ChatInitial()) {
    Stream stream;

    on<ChatEvent>((event, emit) async {
      if (event is ShowUsersChatsEvent) {
        try {
          emit(showUsersChatsLoading());

          final result =
              await FirebaseFirestore.instance.collection('UsersData').get();

          usersResult = result.docs.map((e) => e.data()).toList();

          for (int i = 0; i < usersResult.length; i++) {
            if (usersResult[i]['userId'] ==
                FirebaseAuth.instance.currentUser!.uid) {
              usersResult.remove(usersResult[i]);
            }
          }

          emit(showUsersChatsSuccess());
        } catch (e) {
          emit(showUsersChatsError());
          print(e.toString());
        }
      }
      if (event is ShowUserMessagesEvent) {
        try {
          emit(showUserMessagesLoading());

          String myId = FirebaseAuth.instance.currentUser!.uid;

          String messageRoomId;
          if (myId.compareTo(peerId!) > 0) {
            messageRoomId = '$myId-$peerId';
          } else {
            messageRoomId = '$peerId-$myId';
          }

          stream = await FirebaseFirestore.instance
              .collection('Messages')
              .doc(messageRoomId)
              .collection('TwoPeople').orderBy('time',descending: true)
              .snapshots();

          emit(showUserMessagesSuccess(stream: stream));
        } catch (e) {
          emit(showUserMessagesError());
          print(e.toString());
        }
      }
      if (event is AddMessageEvent) {
        try {
          emit(addMessageLoading());

          String myId = FirebaseAuth.instance.currentUser!.uid;

          String messageRoomId;
          if (myId.compareTo(peerId!) > 0) {
            messageRoomId = '$myId-$peerId';
          } else {
            messageRoomId = '$peerId-$myId';
          }

          String messageId = Uuid().v4();

          FirebaseFirestore.instance
              .collection('Messages')
              .doc(messageRoomId)
              .collection('TwoPeople')
              .doc(messageId)
              .set({
            'messageOwnerId': myId,
            'message': event.message,
            'peerId': peerId,
            'time': DateTime.now(),
          });

          emit(addMessageSuccess());
        } catch (e) {
          emit(addMessageError());
          print(e.toString());
        }
      }
    });
  }
}
