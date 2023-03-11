import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List searchResult = [];

  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is SearchProcessEvent) {
        try {
          emit(SearchLoadingState());

          final result = await FirebaseFirestore.instance
              .collection('UsersData')
              .where('name', isGreaterThanOrEqualTo: event.query)
              .where('name', isLessThan: event.query + 'z')
              .get();

          searchResult = result.docs.map((e) => e.data()).toList();

          for (int i = 0; i < searchResult.length; i++) {
            if (searchResult[i]['userId'] ==
                FirebaseAuth.instance.currentUser!.uid) {
              searchResult.remove(searchResult[i]);
            }
          }

          emit(SearchSuccessState(result: searchResult));
        } catch (e) {
          emit(SearchErrorState(error: e.toString()));
          print(e.toString());
        }
      }

    });
  }
}
