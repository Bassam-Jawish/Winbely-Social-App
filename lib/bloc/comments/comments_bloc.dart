import 'package:bloc/bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'comments_event.dart';

part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  List commentsResult = [];

  CommentsBloc() : super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) async {
      if (event is ShowCommentsEvent) {
        try {
          emit(ShowCommentsLoading());

          final comments = await FirebaseFirestore.instance
              .collection('Comments').where('postId', isEqualTo: commentPostId)
              .orderBy(
              'time', descending: true
          )
              .get();
          commentsResult = comments.docs.map((e) => e.data()).toList();

          print(commentsResult);

          emit(ShowCommentsSuccess(result: commentsResult));
        } catch (e) {
          emit(ShowCommentsError());
          print(e.toString());
        }
      }
      if (event is AddCommentsEvent) {
        try {
          emit(AddCommentsLoading());

          String commentId = Uuid().v4();

          FirebaseFirestore.instance.collection('Comments').doc(commentId).set({
          'commentId': commentId,
          'comment': event.comment,
          'postId': commentPostId,
          'name': commentName,
          'profileUrl': commentProfileUrl,
          'time': DateTime.now(),
          });

          emit(AddCommentsSuccess());
        } catch (e) {
          emit(AddCommentsError());
          print(e.toString());
        }
      }
    });
  }
}
