part of 'user_search_bloc.dart';

class UserSearchEvent extends Equatable {
  const UserSearchEvent();

  @override
  List<Object> get props => [];
}

class UserSearchInitEvent extends UserSearchEvent {}

class OnFieldChangveEvemt extends UserSearchEvent {
  final String? value;
  const OnFieldChangveEvemt({this.value});
}

class OnSearchSendEvent extends UserSearchEvent {
  final String? value;
  const OnSearchSendEvent({this.value});
}

class ResetSearchStatus extends UserSearchEvent{}