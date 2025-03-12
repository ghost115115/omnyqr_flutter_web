import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';

import '../../../commons/utils/api_response.dart';
import '../../main_container/bloc/container_event.dart';
part 'personal_area_event.dart';
part 'personal_area_state.dart';

class PersonalAreaBloc extends Bloc<PersonalAreaEvent, PersonalAreaState> {
  final UserRepository _repository;
  final ContainerBloc _containerBloc;
  PersonalAreaBloc(this._repository, this._containerBloc)
      : super(PersonalAreaInitial()) {
    on<InitEvent>(_onInit);
    on<DeleteAccount>(_onDelete);
    on<ToggleHideShowEvent>(_onHide);
  }
  _onInit(InitEvent event, Emitter<PersonalAreaState> emit) {
    emit(state.copyWith(isIncognito: event.value));
  }

  _onDelete(DeleteAccount event, Emitter<PersonalAreaState> emit) async {
    var response = await _repository.deleteAccount();
    if (response.isSuccess) {
      emit(state.copyWith(status: AccountDeleteStatus.success));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(status: AccountDeleteStatus.networkError));
          break;
        default:
          emit(state.copyWith(status: AccountDeleteStatus.error));
      }
    }
  }

  _onHide(ToggleHideShowEvent event, Emitter<PersonalAreaState> emit) async {
    emit(state.copyWith(upStatus: UpdateStatus.loading));
    User? user = _containerBloc.state.user;
    User newUser = User(
        name: user?.name,
        surname: user?.surname,
        email: user?.email,
        isIncognito: state.isIncognito == true ? false : true);

    ApiResponse<User> updatedUser = await _repository.upDateUser(newUser);

    if (updatedUser.isSuccess) {
      _containerBloc.add(UpdateUserEvent(user: updatedUser.value));

      emit(state.copyWith(
          isIncognito: state.isIncognito == true ? false : true,
          upStatus: UpdateStatus.success));
    } else {
      emit(state.copyWith(upStatus: UpdateStatus.error));
    }
  }
}
