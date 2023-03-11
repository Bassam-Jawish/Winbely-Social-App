part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent {}

class checkInternetEvent extends InternetEvent {}

class ConnectedEvent extends InternetEvent {}

class NotConnectedEvent extends InternetEvent {}