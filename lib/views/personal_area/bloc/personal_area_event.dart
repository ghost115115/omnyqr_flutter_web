part of 'personal_area_bloc.dart';

class PersonalAreaEvent extends Equatable {
  const PersonalAreaEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends PersonalAreaEvent {
  final bool? value;
 const InitEvent(this.value);
}

class DeleteAccount extends PersonalAreaEvent {}

class ToggleHideShowEvent extends PersonalAreaEvent {}
