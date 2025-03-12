part of 'availabilities_bloc.dart';

enum UpdateStatus { init, success, error, networkError }

List<String> days = [
  tr('monday'),
  tr('tuesday'),
  tr('wednesday'),
  tr('thursday'),
  tr('friday'),
  tr('saturday'),
  tr('sunday'),
];

class AvailabilitiesState extends Equatable {
  final List<Availability>? availabilities;
  final String? id;
  final UpdateStatus? status;
  final bool? isloading;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  const AvailabilitiesState(
      {this.availabilities,
      this.id,
      this.startTime,
      this.endTime,
      this.status = UpdateStatus.init,
      this.isloading = true});

  AvailabilitiesState copyWith(
      {List<Availability>? availabilities,
      String? id,
      UpdateStatus? status,
      TimeOfDay? startTime,
      TimeOfDay? endTime,
      bool? isloading}) {
    return AvailabilitiesState(
        availabilities: availabilities ?? this.availabilities,
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        isloading: isloading ?? this.isloading);
  }

  @override
  List<Object?> get props =>
      [availabilities, id, status, startTime, isloading, endTime];
}

class AvailabilitiesInitial extends AvailabilitiesState {}
