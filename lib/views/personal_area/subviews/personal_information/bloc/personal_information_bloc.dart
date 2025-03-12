import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
part 'personal_information_event.dart';
part 'personal_information_state.dart';

class PersonalInformationBloc
    extends Bloc<PersonalInformationEvent, PersonalInformationState> {
  final UserRepository _userRepository;
  final ContainerBloc _containerBloc;
  PersonalInformationBloc(this._containerBloc, this._userRepository)
      : super(PersonalInformationInitial()) {
    on<InitEvent>(_onInit);
    on<NameChangeEvemt>(_onName);
    on<SurnameChangeEvent>(_onSurname);
    on<EmailChangeEvent>(_onEmail);
    on<OnSendEvent>(_onSend);
    on<ResetDialogEvent>(_onReset);
  }
  _onInit(InitEvent event, Emitter<PersonalInformationState> emit) async {
    User? user = _containerBloc.state.user;

    if (user != null) {
      emit(state.copyWith(
          name: user.name,
          nameHint: tr('name'),
          surname: user.surname,
          email: user.email,
          status: EditStatus.init));
    }
  }

  _onName(NameChangeEvemt event, Emitter<PersonalInformationState> emit) {
    emit(state.copyWith(name: event.value));
  }

  _onSurname(SurnameChangeEvent event, Emitter<PersonalInformationState> emit) {
    emit(state.copyWith(surname: event.value));
  }

  _onEmail(EmailChangeEvent event, Emitter<PersonalInformationState> emit) {
    emit(state.copyWith(email: event.value));
  }

  _onSend(OnSendEvent event, Emitter<PersonalInformationState> emit) async {
    emit(state.copyWith(status: EditStatus.loading));
    User? user = _containerBloc.state.user;
    User newUser = User(
        name: state.name,
        surname: state.surname,
        email: state.email,
        isIncognito: user?.isIncognito);

    ApiResponse<User> updatedUser = await _userRepository.upDateUser(newUser);

    if (updatedUser.isSuccess) {
      _containerBloc.add(UpdateUserEvent(user: updatedUser.value));
      emit(state.copyWith(status: EditStatus.success));
    } else {
      emit(state.copyWith(status: EditStatus.error));
    }
  }

  _onReset(
      ResetDialogEvent event, Emitter<PersonalInformationState> emit) async {
    emit(state.copyWith(status: EditStatus.init));
  }
}
