import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/models/password_obj.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository _userRepository;
  ChangePasswordBloc(this._userRepository) : super(ChangePasswordInitial()) {
    on<ToggleShowNewPasswordEvent>(_onShowNew);
    on<ToggleShowOldPasswordEvent>(_onShowOld);
    on<ToggleShowConfirmPasswordEvent>(_onShowConfirm);
    on<OldPasswordChangeEvent>(_onOld);
    on<NewPasswordChangeEvent>(_onNew);
    on<ConfirmNewPasswordChangeEvent>(_onConfirm);
    on<SendPasswordFormEvent>(_onSend);
    on<ResetPasswordDialog>(_onReset);
  }
  _onShowNew(
      ToggleShowNewPasswordEvent event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(showNewPassword: !state.showNewPassword));
  }

  _onShowOld(
      ToggleShowOldPasswordEvent event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(showOldPassword: !state.showOldPassword));
  }

  _onShowConfirm(
      ToggleShowConfirmPasswordEvent event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(showRepeatPassword: !state.showRepeatPassword));
  }

  _onOld(OldPasswordChangeEvent event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(oldPassword: event.oldPassword));
  }

  _onNew(NewPasswordChangeEvent event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(newPassword: event.newPassword));
  }

  _onConfirm(
      ConfirmNewPasswordChangeEvent event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  _onSend(
      SendPasswordFormEvent event, Emitter<ChangePasswordState> emit) async {
    emit(state.copyWith(isLoading: true));
    PassWordObj obj = PassWordObj(state.oldPassword, state.newPassword);
    var response = await _userRepository.changePassword(obj);
    if (response.isSuccess) {
      emit(state.copyWith(status: PasswordStatus.success, isLoading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: PasswordStatus.networkError, isLoading: false));
          break;
        default:
          emit(state.copyWith(status: PasswordStatus.error, isLoading: false));
      }
    }
  }

  _onReset(ResetPasswordDialog event, Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(status: PasswordStatus.init));
  }
}
