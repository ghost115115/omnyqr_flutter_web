part of 'personal_information_bloc.dart';

enum EditStatus { init, loading, success, error, networkError }

class PersonalInformationState extends Equatable {
  final EditStatus? status;
  final String? name;
  final String? nameHint;
  final String? surname;
  final String? email;

  const PersonalInformationState(
      {this.email, this.name,this.nameHint, this.surname, this.status = EditStatus.loading});

  PersonalInformationState copyWith(
      {String? name,String?nameHint, String? surname, String? email, EditStatus? status}) {
    return PersonalInformationState(
        name: name ?? this.name,
        nameHint: nameHint ?? this.nameHint,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [name,nameHint, surname, email, status];
}

class PersonalInformationInitial extends PersonalInformationState {}
