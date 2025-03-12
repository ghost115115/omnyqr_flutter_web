part of 'personal_information_bloc.dart';

class PersonalInformationEvent extends Equatable {
  const PersonalInformationEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends PersonalInformationEvent {}

class NameChangeEvemt extends PersonalInformationEvent {
  final String? value;
  const NameChangeEvemt({this.value});
}

class SurnameChangeEvent extends PersonalInformationEvent {
  final String? value;
  const SurnameChangeEvent({this.value});
}

class EmailChangeEvent extends PersonalInformationEvent {
  final String? value;
  const EmailChangeEvent({this.value});
}

class OnSendEvent extends PersonalInformationEvent {}

class ResetDialogEvent extends PersonalInformationEvent{}