import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:omnyqr/bloc/authentication_bloc.dart';
import 'package:omnyqr/commons/constants/omny_account_type.dart';
import 'package:omnyqr/models/purchase_model.dart';
import 'package:omnyqr/models/thread.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
import 'package:omnyqr/services/signaling_service.dart';
import '../../../commons/utils/api_response.dart';
import '../../../models/associations.dart';
import '../../../repositories/utilities/utility_repo.dart';
import 'container_event.dart';
import 'container_state.dart';

class ContainerBloc extends Bloc<ContainerEvent, ContainerState> {
  final MessageRepository _messageRepository;
  final AuthenticationBloc authenticationBloc;
  final PreferencesRepo preferencesRepo;
  final UtilityRepository utilityRepository;
  final UserRepository userRepository;
  ContainerBloc(this._messageRepository, this.authenticationBloc,
      this.preferencesRepo, this.utilityRepository, this.userRepository)
      : super(ContainerInitializing()) {
    on<ContainerInit>(_initState);
    on<BottomBarSelectionChange>(_bottomBarSelection);
    on<ContainerShowLoading>(_showLoading);
    on<ContainerHideLoading>(_hideLoading);
    on<RefreshUtilities>(_onRefresh);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserEvent>(_onUser);
    on<RefreshThreadsEvent>(_onRefreshThreads);
    on<SendNotificationEvent>(_onSendNotification);
    on<SetUserAvailability>(_onReset);
    on<SetIsAccepted>(_onSet);
    on<SetAccountLevelEvent>(_onLevel);
    on<LoadUtilsEvent>(_load);
    on<SetIndexCall>(_onSetIndex);
  }

  void _initState(ContainerInit event, Emitter<ContainerState> emit) async {
    User? user = await preferencesRepo.getUser();
    //"At the first launch of the app, the user will be null, so it's not possible to
    // execute the server signaling init.
    //Therefore, the server signaling init has also been added in the post-login phase."

    if (user != null) {
      final String? ssUrl = dotenv.env["SS_URL"];
      String websocketUrl = ssUrl ?? '';

      final String selfCallerID = user.id ?? '';

      SignallingService.instance.init(
          websocketUrl: websocketUrl,
          selfCallerID: selfCallerID,
          callKit: 'false');
      emit(state.copyWith(
          user: user, accountType: getAccountType(user.premiumStatus ?? '')));
      // signalling server url
    }

    ApiResponse<List<Association>> response =
        await utilityRepository.getUtilities();
    ApiResponse<List<Thread>?> threadsResponse =
        await _messageRepository.getThreads();
    if (response.isSuccess && threadsResponse.isSuccess) {
      emit(state.copyWith(
          associations: response.value,
          threads: threadsResponse.value,
          status: UtilityStatus.loaded,
          user: user));
    } else {
      switch (response.message ?? threadsResponse.message) {
        case "connectionError":
          emit(state.copyWith(
              status: UtilityStatus.networkError, bottomIndex: 0, user: user));
          break;
        default:
          emit(state.copyWith(
              status: UtilityStatus.error, bottomIndex: 0, user: user));
      }
    }
  }

  void _hideLoading(ContainerHideLoading chl, Emitter<ContainerState> emit) {
    emit(state.copyWith(showLoading: false));
  }

  void _showLoading(ContainerShowLoading csl, Emitter<ContainerState> emit) {
    emit(state.copyWith(showLoading: true));
  }

  void _bottomBarSelection(
      BottomBarSelectionChange bbs, Emitter<ContainerState> emit) async {
    emit(state.copyWith(
      bottomIndex: bbs.selectedIndex,
    ));
  }

  void _onLogout(LogoutEvent event, Emitter<ContainerState> emit) async {
    SignallingService.instance.socket!.disconnect();
    authenticationBloc.add(AuthenticationLogoutEvent());
    preferencesRepo.deleteAccessToken();
    preferencesRepo.deleteRefreshToken();
    preferencesRepo.deleteUser();
    emit(ContainerInitializing());
  }

  _onRefresh(RefreshUtilities event, Emitter<ContainerState> emit) async {
    emit(state.copyWith(status: UtilityStatus.loading));
    ApiResponse<List<Association>> response =
        await utilityRepository.getUtilities();

    if (response.isSuccess) {
      emit(state.copyWith(
        associations: response.value,
        status: UtilityStatus.loaded,
      ));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
            status: UtilityStatus.networkError,
          ));
          break;
        default:
          emit(state.copyWith(
            status: UtilityStatus.error,
          ));
      }
    }
  }

  _onUser(UpdateUserEvent event, Emitter<ContainerState> emit) async {
    // await preferencesRepo.deleteUser();
    await preferencesRepo.saveUser(event.user);
    emit(state.copyWith(user: event.user));
  }

  _onRefreshThreads(
      RefreshThreadsEvent event, Emitter<ContainerState> emit) async {
    emit(state.copyWith(status: UtilityStatus.loading));
    ApiResponse<List<Thread>?> threadsResponse =
        await _messageRepository.getThreads();

    if (threadsResponse.isSuccess) {
      emit(state.copyWith(
          threads: threadsResponse.value,
          status: UtilityStatus.loaded,
          loadedMessage: true,
          bottomIndex: event.isInvitation == true ? 2 : null));
    } else {
      switch (threadsResponse.message) {
        case "connectionError":
          emit(state.copyWith(
              status: UtilityStatus.networkError, loadedMessage: true));
          break;
        default:
          emit(
              state.copyWith(status: UtilityStatus.error, loadedMessage: true));
      }
    }
  }

  _onSendNotification(
      SendNotificationEvent event, Emitter<ContainerState> emit) async {
    /*ApiResponse<String> response = await _messageRepository.sendPush(
        event.id ?? '', event.type ?? '', event.name ?? '');*/
    final calleeId = (kIsWeb && (event.id == null || event.id!.isEmpty))
        ? 'web-test-callee-id'
        : event.id ?? '';

    final notifType = (kIsWeb && (event.type == null || event.type!.isEmpty))
        ? 'CALL'
        : event.type ?? '';

    final utilityName = event.name ?? 'Web Test';

    ApiResponse<String> response = await _messageRepository.sendPush(
      calleeId,
      notifType,
      utilityName,
    );

    if (response.isSuccess) {
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
            status: UtilityStatus.networkError,
          ));
          break;
        default:
        /**
   *         emit(state.copyWith(
            status: UtilityStatus.error,
          ));
   */
      }
    }
  }

  _onReset(SetUserAvailability event, Emitter<ContainerState> emit) {
    emit(state.copyWith(availability: event.availability));
  }

  _onSet(SetIsAccepted event, Emitter<ContainerState> emit) {
    emit(state.copyWith(isAccepted: event.isAccepted));
  }

  _onLevel(SetAccountLevelEvent event, Emitter<ContainerState> emit) async {
    String? platform;
    if (Platform.isAndroid) {
      platform = 'google_play';
    } else if (Platform.isIOS) {
      platform = 'app_store';
    }

    String? level;
    if (event.value != null) {
      if (event.value?.contains('enterprise') == true) {
        level = 'business';
      } else if (event.value?.contains('business') == true) {
        level = 'business';
      } else if (event.value?.contains('pro') == true) {
        level = 'pro';
      } else {
        level = 'free';
      }
    }

    PurchaseModel model;

    model = PurchaseModel(
        level, PurchaseData(event.productID, event.token, platform));

    ApiResponse<User> response = await userRepository.upDateUserLvl(model);

    if (response.isSuccess) {
      preferencesRepo.saveUser(response.value);

      emit(state.copyWith(
          user: response.value,
          accountType: getAccountType(response.value?.premiumStatus ?? '')));
    }
  }

  void _load(LoadUtilsEvent event, Emitter<ContainerState> emit) async {
    ApiResponse<User> mydata = await userRepository.getMyData();
    ApiResponse<List<Association>> response =
        await utilityRepository.getUtilities();
    ApiResponse<List<Thread>?> threadsResponse =
        await _messageRepository.getThreads();

    if (mydata.isSuccess && response.isSuccess && threadsResponse.isSuccess) {
      User? user = mydata.value;
      await preferencesRepo.saveUser(mydata.value);
      emit(state.copyWith(
          associations: response.value,
          threads: threadsResponse.value,
          status: UtilityStatus.loaded,
          accountType: getAccountType(mydata.value?.premiumStatus ?? ''),
          user: user));
    } else {
      emit(state.copyWith(
        status: UtilityStatus.initFail,
      ));
    }
  }

  void _onSetIndex(SetIndexCall event, Emitter<ContainerState> emit) {
    emit(
      state.copyWith(callIndex: event.indexCall),
    );
  }
}
