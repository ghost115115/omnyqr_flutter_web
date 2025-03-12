import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final AuthRepository _authRepository;
  PasswordResetBloc(this._authRepository) : super(PasswordResetInitial()) {
    on<EmailChangeEvent>(_onChange);
    on<SendEmailEvent>(_onSend);
    on<ResetDialogEvent>(_onReset);
  }

  _onChange(EmailChangeEvent event, Emitter<PasswordResetState> emit) {
    emit(state.copyWith(email: event.value));
  }

  _onSend(SendEmailEvent event, Emitter<PasswordResetState> emit) async {
    emit(state.copyWith(isLoading: true));
    ApiResponse<void> response =
        await _authRepository.pswdReset(state.email ?? '');

    if (response.isSuccess) {
      emit(state.copyWith(
        status: SendResetStatus.success,
      ));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: SendResetStatus.networkError, isLoading: false));
          break;
        case "USER_NOT_FOUND":
          emit(state.copyWith(
              status: SendResetStatus.notFound, isLoading: false));
          break;
        default:
          emit(state.copyWith(status: SendResetStatus.error, isLoading: false));
      }
    }
  }

  _onReset(ResetDialogEvent event, Emitter<PasswordResetState> emit) {
    emit(state.copyWith(status: SendResetStatus.init));
  }
}
