part of 'search_bloc.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoadingState extends SearchState{}
class SearchSuccessState extends SearchState{
  List result = [];

  SearchSuccessState({required this.result});
}
class SearchErrorState extends SearchState
{
  final String error;

  SearchErrorState({required this.error});

}




