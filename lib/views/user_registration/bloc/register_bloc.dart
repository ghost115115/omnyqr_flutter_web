import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/login_response.dart';
import 'package:omnyqr/models/register_obj.dart';
import 'package:omnyqr/repositories/auth/auth_repository.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<RegisterInitEvent>(_onInit);
    on<ToggleShowAdminFieldsEvent>(_onAdmin);
    on<ToggleShowPasswordEvent>(_onPsw);
    on<ToggleShowConfirmPasswordEvent>(_onConfPsw);
    on<NameChangeEvent>(_onNameChange);
    on<SurnameChangeEvent>(_onSurnameChange);
    on<EmailChangeEvent>(_onEmailChange);
    on<PasswordChangeEvent>(_onPasswordChange);
    on<ConfirmPasswordChangeEvent>(_onConfirmChange);
    on<VatChangeEvent>(_onVatChange);
    on<ProfessionaRegisterChangeEvent>(_onProfessionalChange);
    on<SendRegister>(_onRegisterEvent);
    on<ResetDialogEvent>(_onResetDialog);
  }
  _onInit(RegisterInitEvent event, Emitter<RegisterState> emit) {}

  _onSurnameChange(SurnameChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(surname: event.value));
  }

  _onPasswordChange(PasswordChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.value));
  }

  _onConfirmChange(
      ConfirmPasswordChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(confirmPassword: event.value));
  }

  _onVatChange(VatChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(vat: event.value));
  }

  _onProfessionalChange(
      ProfessionaRegisterChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(professionalRegister: event.value));
  }

  _onAdmin(ToggleShowAdminFieldsEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(showAdminField: !state.showAdminField));
  }

  _onEmailChange(EmailChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.value));
  }

  _onPsw(ToggleShowPasswordEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  _onConfPsw(
      ToggleShowConfirmPasswordEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  _onNameChange(NameChangeEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(name: event.value));
  }

  _onResetDialog(ResetDialogEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(status: RegistrationStatus.init));
  }

  _onRegisterEvent(SendRegister event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true));
    if (state.showAdminField == true) {
      RegisterObj registerObj = RegisterObj(
          name: state.name,
          surname: state.surname,
          email: state.email,
          password: state.password,
          isAssociationAdmin: true,
          vat: state.vat,
          professionalEnrollment: state.professionalRegister);

      await sendRegister(registerObj, emit);
    } else {
      RegisterObj registerObj = RegisterObj(
          name: state.name,
          surname: state.surname,
          email: state.email,
          password: state.password,
          isAssociationAdmin: false,
          vat: null,
          professionalEnrollment: null);

      await sendRegister(registerObj, emit);
    }
  }

  Future sendRegister(
    RegisterObj registerObj,
    Emitter<RegisterState> emit,
  ) async {
    ApiResponse<LoginResponse?> response =
        await _authRepository.register(registerObj);

    if (response.isSuccess) {
      emit(
          state.copyWith(status: RegistrationStatus.success, isLoading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: RegistrationStatus.networkError, isLoading: false));
          break;
        case "EMAIL_TAKEN":
          emit(state.copyWith(
              status: RegistrationStatus.emailAlreadyInUse, isLoading: false));
          break;
        default:
          emit(state.copyWith(
              status: RegistrationStatus.error, isLoading: false));
      }
    }
  }
}
