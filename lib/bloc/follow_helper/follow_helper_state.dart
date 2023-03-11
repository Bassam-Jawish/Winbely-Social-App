part of 'follow_helper_bloc.dart';

@immutable
abstract class FollowHelperState {}

class FollowHelperInitial extends FollowHelperState {}

class FollowLoadingState extends FollowHelperState{}

class FollowLSuccessState extends FollowHelperState{}

class FollowErrorState extends FollowHelperState{}


class UnfollowLoadingState extends FollowHelperState{}

class UnfollowLSuccessState extends FollowHelperState{}

class UnfollowErrorState extends FollowHelperState{}