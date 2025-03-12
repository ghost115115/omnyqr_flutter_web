part of 'register_bloc.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterInitEvent extends RegisterEvent {}

class ToggleShowPasswordEvent extends RegisterEvent {}

class ToggleShowConfirmPasswordEvent extends RegisterEvent {}

class ToggleShowAdminFieldsEvent extends RegisterEvent {}

class NameChangeEvent extends RegisterEvent {
  final String? value;
  const NameChangeEvent({this.value});
}

class SurnameChangeEvent extends RegisterEvent {
  final String? value;
  const SurnameChangeEvent({this.value});
}

class EmailChangeEvent extends RegisterEvent {
  final String? value;
  const EmailChangeEvent({this.value});
}

class PasswordChangeEvent extends RegisterEvent {
  final String? value;
  const PasswordChangeEvent({this.value});
}

class ConfirmPasswordChangeEvent extends RegisterEvent {
  final String? value;
  const ConfirmPasswordChangeEvent({this.value});
}

class VatChangeEvent extends RegisterEvent {
  final String? value;
  const VatChangeEvent({this.value});
}

class ProfessionaRegisterChangeEvent extends RegisterEvent {
  final String? value;
  const ProfessionaRegisterChangeEvent({this.value});
}

class SendRegister extends RegisterEvent {}

class ResetDialogEvent extends RegisterEvent{}
