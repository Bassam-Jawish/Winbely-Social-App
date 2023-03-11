part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ShowUsersChatsEvent extends ChatEvent {}

class ShowUserMessagesEvent extends ChatEvent {




}

class AddMessageEvent extends ChatEvent {

  final String message;

  AddMessageEvent({required this.message});


}
