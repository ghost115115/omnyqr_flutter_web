import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import '../../../commons/constants/omny_qr_type.dart';
import '../../../commons/utils/api_response.dart';
import '../../../models/associations.dart';
import '../../create_edit_qr/bloc/create_edit_qr_bloc.dart';
part 'association_event.dart';
part 'association_state.dart';

class AssociationBloc extends Bloc<AssociationEvent, AssociationState> {
  final UtilityRepository utilityRepository;
  AssociationBloc(this.utilityRepository) : super(AssociationInitial()) {
    on<AssociationInitEvent>(_onInit);
    on<AssociationRefreshEvemt>(_onRefresh);
    on<ResetAssociationStatus>(_onReset);
  }

  _onInit(AssociationInitEvent event, Emitter<AssociationState> emit) async {
    print('[DEBUG] AssociationInitEvent ricevuto');

    emit(state.copyWith(isLoading: true));



    switch (getQrType(event.value ?? '')) {
      case QrType.mine:
        emit(state.copyWith(
          title: tr('select_condominium'),
        ));
        print('[DEBUG] Stato aggiornato con nuove associazioni - mine');

        break;
      case QrType.business:
        emit(state.copyWith(
          title: tr('select_business'),
        ));
        print('[DEBUG] Stato aggiornato con nuove associazioni - Buss');

        break;

      default:
    }

    ApiResponse<List<Association>> response =
        await utilityRepository.getMyAssociations();

    if (response.isSuccess) {
      emit(state.copyWith(associations: response.value, isLoading: false));
    } else {
      // here we handle the exeptions

      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: AssociationSearch.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(
              status: AssociationSearch.error, isLoading: false));
      }
    }
  }

  _onRefresh(
      AssociationRefreshEvemt event, Emitter<AssociationState> emit) async {
    ApiResponse<List<Association>> response =
        await utilityRepository.getMyAssociations();
    if (response.isSuccess) {
      emit(state.copyWith(associations: response.value));
    } else {
      // here we handle the exeptions

      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: AssociationSearch.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(
              status: AssociationSearch.error, isLoading: false));
      }
    }
  }

  _onReset(ResetAssociationStatus event, Emitter<AssociationState> emit) {
    emit(state.copyWith(status: AssociationSearch.init));
  }
}
