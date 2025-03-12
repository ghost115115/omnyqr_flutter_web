part of 'availabilities_bloc.dart';

class AvailabilitiesEvent extends Equatable {
  const AvailabilitiesEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends AvailabilitiesEvent {
  final String? id;
  const InitEvent({this.id});
}

class StartDateChangeEvent extends AvailabilitiesEvent {
  final TimeOfDay? value;
  final int? index;
  const StartDateChangeEvent({this.value, this.index});
}

class EndDateChangeEvent extends AvailabilitiesEvent {
  final TimeOfDay? value;
  final int? index;
  const EndDateChangeEvent({this.value, this.index});
}

class ToggleDay extends AvailabilitiesEvent {
  final bool? value;
  final int? index;
  const ToggleDay({this.value, this.index});
}


class UpdateAvailabilitiesEvent extends AvailabilitiesEvent{}

class ResetDialog extends AvailabilitiesEvent{}