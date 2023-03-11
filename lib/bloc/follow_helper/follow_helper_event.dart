part of 'follow_helper_bloc.dart';

@immutable
abstract class FollowHelperEvent {}

class FollowEvent extends FollowHelperEvent {
  final String followUserId;

  FollowEvent({required this.followUserId});

}

class UnfollowEvent extends FollowHelperEvent {
  final String unfollowUserId;

  UnfollowEvent({required this.unfollowUserId});
}