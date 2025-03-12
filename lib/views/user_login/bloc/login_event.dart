part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInitEvent extends LoginEvent {}

class SendLoginEvent extends LoginEvent {}

class EmailChangeEvent extends LoginEvent {
  final String? value;
  const EmailChangeEvent({this.value});
}

class PasswordChangeEvent extends LoginEvent {
  final String? value;
  const PasswordChangeEvent({this.value});
}

class ResetDialogEvent extends LoginEvent {}

class ToggleShowPasswordEvent extends LoginEvent {}
