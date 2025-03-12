part of 'password_reset_bloc.dart';

class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class EmailChangeEvent extends PasswordResetEvent {
  final String? value;
  const EmailChangeEvent({this.value});
}

class SendEmailEvent extends PasswordResetEvent{}

class ResetDialogEvent extends PasswordResetEvent{}
