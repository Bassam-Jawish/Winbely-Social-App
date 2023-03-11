part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchProcessEvent extends SearchEvent {
  final String query;

  SearchProcessEvent({required this.query});
}

