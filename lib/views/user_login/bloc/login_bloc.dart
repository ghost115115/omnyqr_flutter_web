import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mine_pushkit/mine_pushkit.dart';
import 'package:omnyqr/bloc/authentication_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/login_response.dart';
import 'package:omnyqr/repositories/device/device_repository.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/services/signaling_service.dart';
import '../../../repositories/auth/auth_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  final DeviceRepository _deviceRepository;
  final PreferencesRepo preferencesRepo;
  final AuthRepository authRepository;
  LoginBloc(
    this.authenticationBloc,
    this.authRepository,
    this._deviceRepository,
    this.preferencesRepo,
  ) : super(LoginInitial()) {
    on<LoginInitEvent>(_onInit);
    on<SendLoginEvent>(_onSend);
    on<PasswordChangeEvent>(_onPassword);
    on<EmailChangeEvent>(_onEmail);
    on<ToggleShowPasswordEvent>(_togglePasswordObscuration);
    on<ResetDialogEvent>(_onReset);
  }

  _onInit(LoginInitEvent event, Emitter<LoginState> emit) {}

  _onPassword(PasswordChangeEvent event, Emitter<LoginState> emit) {
    state.password = event.value;
  }

  _onEmail(EmailChangeEvent event, Emitter<LoginState> emit) {
    state.email = event.value;
  }

  void _togglePasswordObscuration(
      ToggleShowPasswordEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  _onSend(SendLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));
    ApiResponse<LoginResponse?> response =
        await authRepository.loginUser(state.email ?? '', state.password ?? '');

    if (response.isSuccess) {
      //check per vedere se si è convalidata la mail
      if (response.value?.user?.isVerified == true) {
        await preferencesRepo.saveToken(response.value?.tokens?.access?.token);
        await preferencesRepo
            .saveRefreshToken(response.value?.tokens?.refresh?.token);
        await preferencesRepo.saveUser(response.value?.user);

        // ignore: unused_local_variable
        String? fbToken;
        bool emulator = await isEmulator();
        if (!emulator) {
          fbToken = await FirebaseMessaging.instance.getToken();
        }
        var apnToken = "";

        if (response.value?.user != null) {
          final String? ssUrl = dotenv.env["SS_URL"];
          String websocketUrl = ssUrl ?? '';

          final String selfCallerID = response.value?.user?.id ?? '';

          SignallingService.instance.init(
              websocketUrl: websocketUrl,
              selfCallerID: selfCallerID,
              callKit: 'false');
        }
        if (Platform.isIOS) {
          apnToken = MinePushkit.instance.token ?? '';
        }

        await _deviceRepository.registerFcmToken(fbToken ?? '', apnToken);
        authenticationBloc.add(AuthenticationLoggedEvent());
        // check nell'account per verificare se si è stati bannati
        if (response.value?.user?.enabled == false) {
          emit(state.copyWith(
              status: LoginStatus.accountDisabled, isLoading: false));
        } else {
          emit(state.copyWith(
              status: LoginStatus.authenticated, isLoading: false));
        }
      } else {
        emit(state.copyWith(
            status: LoginStatus.accountNotActive, isLoading: false));
      }
    } else {
      // here we handle the exeptions
      switch (response.message) {
        case "INVALID_CREDENTIALS":
          emit(state.copyWith(
              status: LoginStatus.authWrongCrendential, isLoading: false));
          break;
        case "connectionError":
          emit(state.copyWith(
              status: LoginStatus.networkError, isLoading: false));
          break;
        default:
          emit(state.copyWith(
              status: LoginStatus.authenticationError, isLoading: false));
      }
    }
  }

  _onReset(ResetDialogEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.init));
  }

  Future<bool> isEmulator() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice == false;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice == false;
    }
    // Default to false if the platform isn't Android or iOS
    return false;
  }
}
