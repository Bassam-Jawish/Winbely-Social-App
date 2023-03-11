part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class showUsersChatsLoading extends ChatState {}

class showUsersChatsSuccess extends ChatState {}

class showUsersChatsError extends ChatState {}

class showUserMessagesLoading extends ChatState {}

class showUserMessagesSuccess extends ChatState {
  Stream stream;

  showUserMessagesSuccess({required this.stream});

}

class showUserMessagesError extends ChatState {}

class addMessageLoading extends ChatState {}

class addMessageSuccess extends ChatState {}

class addMessageError extends ChatState {}
