part of 'call_deviation_bloc.dart';

abstract class CallDeviationEvent extends Equatable {
  const CallDeviationEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitEvent extends CallDeviationEvent {
  const InitEvent();
}

class SelectCheckboxEvent extends CallDeviationEvent {
  final int indexSelected;
  final bool? value;
  const SelectCheckboxEvent(
    this.indexSelected,
    this.value,
  );
}

class SaveEvent extends CallDeviationEvent {
  const SaveEvent();
}

class ResetAlert extends CallDeviationEvent {
  const ResetAlert();
}
