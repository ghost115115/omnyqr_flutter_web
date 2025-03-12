import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import '../../../commons/constants/omny_qr_type.dart';
import '../../../models/associations.dart';
import '../../create_edit_qr/bloc/create_edit_qr_bloc.dart';
part 'association_create_event.dart';
part 'association_create_state.dart';

class AssociationCreateBloc
    extends Bloc<AssociationCreateEvent, AssociationCreateState> {
  final UtilityRepository _utilityRepository;
  AssociationCreateBloc(this._utilityRepository)
      : super(AssociationCreateInitial()) {
    on<AssociationCreateInitEvent>(_onInit);
    on<NameChangeEvent>(_onName);
    on<AddressChangeEvent>(_onAddress);
    on<FormSendEvent>(_onSend);
    on<AssociationCreateEvent>(_onReset);
  }

  _onInit(
      AssociationCreateInitEvent event, Emitter<AssociationCreateState> emit) {
    switch (getQrType(event.value ?? '')) {
      case QrType.mine:
        emit(state.copyWith(
            title: tr('create_condominium'),
            labelTitle: tr('condominium_name'),
            associationType: event.value));
        break;
      case QrType.business:
        emit(state.copyWith(
            title: tr('create_business'),
            labelTitle: tr('business_name'),
            associationType: event.value));
        break;
      default:
    }
  }

  _onName(NameChangeEvent event, Emitter<AssociationCreateState> emit) {
    emit(state.copyWith(name: event.value));
  }

  _onAddress(AddressChangeEvent event, Emitter<AssociationCreateState> emit) {
    emit(state.copyWith(
        address: event.value,
        lat: double.parse(event.lat ?? '0.0'),
        long: double.parse(event.long ?? '0.0')));
  }

  _onSend(FormSendEvent event, Emitter<AssociationCreateState> emit) async {
    emit(state.copyWith(isLoading: true));
    ApiResponse<Association> response =
        await _utilityRepository.createAssociation(
            state.name ?? '',
            state.address ?? '',
            state.associationType ?? '',
            state.lat ?? 0.0,
            state.long ?? 0.0);

    if (response.isSuccess) {
      emit(
          state.copyWith(status: AssociationStatus.complete, isLoading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: AssociationStatus.networkError, isLoading: false));
          break;

        default:
          emit(state.copyWith(
              status: AssociationStatus.error, isLoading: false));
      }
    }
  }

  _onReset(AssociationCreateEvent event, Emitter<AssociationCreateState> emit) {
    emit(state.copyWith(status: AssociationStatus.init));
  }
}
