part of 'change_password_bloc.dart';

class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ToggleShowNewPasswordEvent extends ChangePasswordEvent {}

class ToggleShowOldPasswordEvent extends ChangePasswordEvent {}

class ToggleShowConfirmPasswordEvent extends ChangePasswordEvent {}

class OldPasswordChangeEvent extends ChangePasswordEvent {
  final String? oldPassword;
  const OldPasswordChangeEvent({this.oldPassword});
}

class NewPasswordChangeEvent extends ChangePasswordEvent {
  final String? newPassword;
  const NewPasswordChangeEvent({this.newPassword});
}

class ConfirmNewPasswordChangeEvent extends ChangePasswordEvent {
  final String? confirmPassword;
  const ConfirmNewPasswordChangeEvent({this.confirmPassword});
}

class SendPasswordFormEvent extends ChangePasswordEvent {}

class ResetPasswordDialog extends ChangePasswordEvent {}
