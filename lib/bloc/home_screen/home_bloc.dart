import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {

    Stream stream;

    final StreamController<List<DocumentSnapshot>> Controller =
    StreamController<List<DocumentSnapshot>>.broadcast();

    List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

     const int postsLimit = 5;
    DocumentSnapshot? lastDocument;
    bool hasMoreData = true;

    on<HomeEvent>((event, emit) async {
      if (event is GetPostsHomeEvent){
        try{
        emit(GetPostsLoading());

/*
        final CollectionReference collectionReference = FirebaseFirestore
            .instance
            .collection('PostsData');


        var pageQuery = collectionReference
            .orderBy('time', descending: true)
            .limit(postsLimit);


        if (lastDocument != null) {
          pageQuery = pageQuery.startAfterDocument(lastDocument!);
        }

        if (!hasMoreData) return;

        var currentRequestIndex = _allPagedResults.length;
        pageQuery.snapshots().listen(
                (snapshot) {
              if (snapshot.docs.isNotEmpty) {
                var generalPosts = snapshot.docs.toList();

                var pageExists = currentRequestIndex < _allPagedResults.length;

                if (pageExists) {
                  _allPagedResults[currentRequestIndex] = generalPosts;
                } else {
                  _allPagedResults.add(generalPosts);
                }

                var allPosts = _allPagedResults.fold<List<DocumentSnapshot>>(
                    <DocumentSnapshot>[],
                        (initialValue, pageItems) => initialValue..addAll(pageItems));

                Controller.add(allPosts);

                if (currentRequestIndex == _allPagedResults.length - 1) {
                  lastDocument = snapshot.docs.last;
                }

                hasMoreData = generalPosts.length == postsLimit;
              }
            },
        );*/

        stream = await FirebaseFirestore.instance
            .collection('PostsData')
            .orderBy('time', descending: true)
            .snapshots();


        emit(GetPostsSuccess(stream: stream));
      }
      catch (e){
          emit(GetPostsError());
          print(e.toString());
      }
      }
    });
  }
}
