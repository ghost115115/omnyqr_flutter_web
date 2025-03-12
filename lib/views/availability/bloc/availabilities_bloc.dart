import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/availability.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
part 'availabilities_event.dart';
part 'availabilities_state.dart';

class AvailabilitiesBloc
    extends Bloc<AvailabilitiesEvent, AvailabilitiesState> {
  final UtilityRepository _utilityRepository;
  AvailabilitiesBloc(this._utilityRepository) : super(AvailabilitiesInitial()) {
    on<InitEvent>(_onInit);
    on<EndDateChangeEvent>(_onEnd);
    on<StartDateChangeEvent>(_onStart);
    on<ToggleDay>(_onToggle);
    on<UpdateAvailabilitiesEvent>(_onUpdate);
    on<ResetDialog>(_onReset);
  }

  _onInit(InitEvent event, Emitter<AvailabilitiesState> emit) async {
    ApiResponse<List<Availability>> response =
        await _utilityRepository.getAvailabilities(event.id ?? '');
    if (response.isSuccess) {
      ////// Since the days descend in the following order: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, I need to sort them.
      int sortDay(Availability a, Availability b) {
        List<int> giorni = [1, 2, 3, 4, 5, 6, 0];
        return giorni.indexOf(a.day ?? 0) - giorni.indexOf(b.day ?? 0);
      }

      List<Availability>? availabilities = response.value;

      availabilities?.sort(sortDay);

      emit(state.copyWith(
          availabilities: availabilities, id: event.id, isloading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
            status: UpdateStatus.networkError,
          ));
          break;
        default:
          emit(state.copyWith(
            status: UpdateStatus.error,
          ));
      }
    }
  }

  _onEnd(EndDateChangeEvent event, Emitter<AvailabilitiesState> emit) {
    List<Availability>? availabilitiesList = state.availabilities;
    emit(state.copyWith(availabilities: []));
    availabilitiesList?[event.index ?? 0].end =
        "${event.value?.hour.toString().padLeft(2, '0')}:${event.value?.minute.toString().padLeft(2, '0')}";
    List<Availability>? updatedList = availabilitiesList;
    emit(state.copyWith(availabilities: updatedList, endTime: event.value));
  }

  _onStart(StartDateChangeEvent event, Emitter<AvailabilitiesState> emit) {
    List<Availability>? availabilitiesList = state.availabilities;
    emit(state.copyWith(availabilities: []));
    availabilitiesList?[event.index ?? 0].start =
        "${event.value?.hour.toString().padLeft(2, '0')}:${event.value?.minute.toString().padLeft(2, '0')}";

    List<Availability>? updatedList = availabilitiesList;
    emit(state.copyWith(availabilities: updatedList, startTime: event.value));
  }

  _onToggle(ToggleDay event, Emitter<AvailabilitiesState> emit) {
    List<Availability>? availabilitiesList = state.availabilities;
    emit(state.copyWith(availabilities: []));

    availabilitiesList?[event.index ?? 0].isActive = event.value;
    List<Availability>? updatedList = availabilitiesList;
    emit(state.copyWith(availabilities: updatedList));
  }

  _onUpdate(UpdateAvailabilitiesEvent event,
      Emitter<AvailabilitiesState> emit) async {
    emit(state.copyWith(isloading: true));
    var response = await _utilityRepository.updateAvailabilities(
        state.id ?? '', state.availabilities ?? []);
    if (response.isSuccess) {
      emit(state.copyWith(status: UpdateStatus.success, isloading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: UpdateStatus.networkError, isloading: false));
          break;
        default:
          emit(state.copyWith(status: UpdateStatus.error, isloading: false));
      }
    }
  }

  _onReset(ResetDialog event, Emitter<AvailabilitiesState> emit) {
    emit(state.copyWith(status: UpdateStatus.init));
  }
}
