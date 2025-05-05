import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/qr_obj.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import '../../../commons/constants/omny_qr_type.dart';
import '../../../models/associations.dart';
import '../../../models/utility.dart';
import '../../create_edit_qr/bloc/create_edit_qr_bloc.dart';
part 'overview_page_event.dart';
part 'overview_page_state.dart';

class OverviewPageBloc extends Bloc<OverviewPageEvent, OverviewPageState> {
  final UtilityRepository _utilityRepository;
  OverviewPageBloc(this._utilityRepository) : super(OverviewPageInitial()) {
    on<OverviewPageInitEvent>(_onInit);
    on<DeleteUtilityEvent>(_onDelete);
    on<GetQrEvemt>(_onGet);
    on<ResetDialog>(_onReset);
    on<OnOffUtility>(_onOnOff);
    on<DeleteUserEvent>(_onDeleteUser);
    on<PublicPrivateUtility>(_publicPrivate);
  }

  _onInit(OverviewPageInitEvent event, Emitter<OverviewPageState> emit) async {
    //emit(state.copyWith(isLoading: true));


    Utility? data = event.association?.utilities?[event.index ?? 0];

    switch (getQrType(event.association?.associationType ?? '')) {
      case QrType.mine:
        emit(state.copyWith(
            title: tr('mine_title'),
            subTitle: data?.intercomName,
            showName: true,
            showIntercom: true,
            showAddress: true,
            showMember: true,
            showCondominium: event.isReal,
            groupCheckBoxLabel: tr('utils_checkbox_txt'),
            isActive: data?.isActive,
            utility: data,
            associationName: event.association?.name,
            privatePublicToggle: data?.isPrivate));
        break;
      case QrType.business:
        emit(state.copyWith(
            title: tr('business_title'),
            subTitle: data?.intercomName,
            showIntercom: true,
            showAddress: true,
            showMember: true,
            isActive: data?.isActive,
            showCondominium: event.isReal,
            groupCheckBoxLabel: tr('utils_checkbox_office_txt'),
            utility: data,
            associationName: event.association?.name,
            privatePublicToggle: data?.isPrivate));


    break;
      case QrType.lost:
        emit(state.copyWith(
            title: tr('lost_title'),
            intercomNameLabel: tr('name'),
            subTitle: data?.intercomName,
            showIntercom: true,
            showMember: true,
            isActive: data?.isActive,
            utility: data,
            associationName: event.association?.name,
            privatePublicToggle: data?.isPrivate
    ));

        break;
      case QrType.going:
        emit(state.copyWith(
            title: tr('going_on_title'),
            subTitle: data?.intercomName,
            utility: data,
            showIntercom: true,
            intercomNameLabel: tr('event_name'),
            showDate: true,
            showAddress: true,
            isActive: data?.isActive,
            showMember: true,
            associationName: event.association?.name,
            privatePublicToggle: data?.isPrivate
        ));

        break;
      case QrType.emergency:
        emit(state.copyWith(
            title: tr('emergency_title'),
            intercomNameLabel: tr('name'),
            subTitle: data?.intercomName,
            utility: data,
            isActive: data?.isActive,
            showIntercom: true,
            showMember: true,
            associationName: event.association?.name,
            privatePublicToggle: data?.isPrivate
        ));

        break;
      case QrType.price:
        emit(state.copyWith(
            title: tr('fork_title'),
            intercomNameLabel: tr('name'),
            subTitle: data?.intercomName,
            isActive: data?.isActive,
            utility: data,
            showIntercom: true,
            showUrl: data?.utilityLink != null ? true : false,
            showfile: data?.utilityLink != null ? false : true,
            associationName: event.association?.name));

        break;
      case QrType.assistance:
        emit(state.copyWith(
            title: tr('assistance_title'),
            intercomNameLabel: tr('name'),
            subTitle: data?.intercomName,
            isActive: data?.isActive,
            utility: data,
            showIntercom: true,
            showMember: true,
            associationName: event.association?.name,
            privatePublicToggle: data?.isPrivate));

        break;
      default:
    }
  }

  _onDelete(DeleteUtilityEvent event, Emitter<OverviewPageState> emit) async {
    emit(state.copyWith(isLoading: true));
    var response = await _utilityRepository.deleteUtility(
        event.associationId ?? '', event.utilityId ?? '');

    if (response.isSuccess) {
      emit(state.copyWith(status: DeleteStatus.success, isLoading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: DeleteStatus.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(status: DeleteStatus.error, isLoading: false));
      }
    }
  }

  _onDeleteUser(DeleteUserEvent event, Emitter<OverviewPageState> emit) async {
    emit(state.copyWith(isLoading: true));
    var response = await _utilityRepository.deleteUsers(
      event.associationId ?? '',
      event.utilityId ?? '',
    );
    if (response.isSuccess) {
      emit(
        state.copyWith(status: DeleteStatus.logoutUser, isLoading: false),
      );
    } else {
      switch (response.message) {
        case 'connectionError':
          emit(
            state.copyWith(
              status: DeleteStatus.networkError,
              isLoading: false,
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              status: DeleteStatus.error,
              isLoading: false,
            ),
          );
      }
    }
  }

  _onGet(GetQrEvemt event, Emitter<OverviewPageState> emit) async {
    emit(state.copyWith(isLoading: true));
    ApiResponse<QrObj> response =
        await _utilityRepository.getQr(event.associationId ?? '');
    if (response.isSuccess) {
      emit(state.copyWith(
          isLoading: false,
          qrUrl: response.value?.qrCodeDataURL ?? '',
          status: DeleteStatus.showQr));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: DeleteStatus.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(status: DeleteStatus.error, isLoading: false));
      }
    }
  }

  _onReset(ResetDialog event, Emitter<OverviewPageState> emit) async {
    emit(state.copyWith(status: DeleteStatus.init));
  }



  _onOnOff(OnOffUtility event, Emitter<OverviewPageState> emit) async {
    emit(state.copyWith(isLoading: true));

    // ignore: unused_local_variable
    ApiResponse<Utility> response = await _utilityRepository.updateOnOffUtility(
        event.associationId ?? '',
        event.utilityId ?? '',
        state.isActive == true ? false : true,
        state.utility?.referents ?? []);

    if (response.isSuccess) {
      emit(state.copyWith(
          isLoading: false, isActive: state.isActive == true ? false : true));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: DeleteStatus.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(status: DeleteStatus.error, isLoading: false));
      }
    }
  }


  _publicPrivate(
      PublicPrivateUtility event, Emitter<OverviewPageState> emit) async {
    emit(state.copyWith(isLoading: true));
    ApiResponse<Utility> response = await _utilityRepository.updateIsPrivate(
      event.associationId ?? "",
      event.utilityId ?? "",
      event.value ?? false,
      state.utility?.referents ?? [],
    );
    if (response.isSuccess) {
      emit(state.copyWith(
        isLoading: false,
        privatePublicToggle: event.value,
      ));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: DeleteStatus.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(status: DeleteStatus.error, isLoading: false));
      }
    }
  }
}
