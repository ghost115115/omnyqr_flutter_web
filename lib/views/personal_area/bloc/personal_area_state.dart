part of 'personal_area_bloc.dart';

enum AccountDeleteStatus { init, success, error, networkError }

enum UpdateStatus { init, success, error, networkError,loading }

class PersonalAreaState extends Equatable {
  final AccountDeleteStatus? status;
  final UpdateStatus? upStatus;
  final bool? isIncognito;
  const PersonalAreaState({this.status, this.isIncognito, this.upStatus});
  PersonalAreaState copyWith(
      {AccountDeleteStatus? status,
      bool? isIncognito,
      UpdateStatus? upStatus}) {
    return PersonalAreaState(
        status: status ?? this.status,
        isIncognito: isIncognito ?? this.isIncognito,
        upStatus: upStatus ?? this.upStatus);
  }

  @override
  List<Object?> get props => [status, isIncognito, upStatus];
}

class PersonalAreaInitial extends PersonalAreaState {}
