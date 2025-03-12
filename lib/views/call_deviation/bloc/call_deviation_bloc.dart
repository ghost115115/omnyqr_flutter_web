import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/utility_unavailability.dart';
import '../../../repositories/utilities/utility_repo.dart';

part 'call_deviation_event.dart';
part 'call_deviation_state.dart';

class CallDeviationBloc extends Bloc<CallDeviationEvent, CallDeviationState> {
  final UtilityRepository _utilityRepository;

  CallDeviationBloc(
    this._utilityRepository,
  ) : super(CallDeviationInitial()) {
    on<InitEvent>(_onInit);
    on<SelectCheckboxEvent>(_onSelectCheckboxEvent);
    on<SaveEvent>(_onSaveEvent);
    on<ResetAlert>(_onResetAlert);
  }

  _onInit(InitEvent event, Emitter<CallDeviationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await _utilityRepository.getUtilityUnavailability();
    if (data.isSuccess) {
      emit(
        state.copyWith(
          isLoading: false,
          utilityUnavailability: data.value,
        ),
      );
    } else {
      switch (data.message) {
        case "connectionError":
          emit(
            state.copyWith(
              isLoading: false,
              message: CallDeviationError.networkError,
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              isLoading: false,
              message: CallDeviationError.error,
            ),
          );
          break;
      }
    }
  }

  _onSelectCheckboxEvent(
      SelectCheckboxEvent event, Emitter<CallDeviationState> emit) {
    var lista = state.utilityUnavailability ?? [];
    emit(
      state.copyWith(
        utilityUnavailability: [],
      ),
    );
    lista[event.indexSelected].isUnavailable = event.value;
    emit(
      state.copyWith(
        utilityUnavailability: lista,
      ),
    );
  }

  _onSaveEvent(SaveEvent event, Emitter<CallDeviationState> emit) async {
    if (state.utilityUnavailability != null) {
      final response = await _utilityRepository
          .putUtilityUnavailability(state.utilityUnavailability ?? []);

      if (response.isSuccess) {
        // TODO: ESCI? AVISO? BOH ?
        emit(
          state.copyWith(
            isLoading: false,
            message: CallDeviationError.success,
          ),
        );
      } else {
        switch (response.message) {
          case "connectionError":
            emit(
              state.copyWith(
                isLoading: false,
                message: CallDeviationError.networkError,
              ),
            );
            break;
          default:
            emit(
              state.copyWith(
                isLoading: false,
                message: CallDeviationError.error,
              ),
            );
            break;
        }
      }
    }
  }

  _onResetAlert(ResetAlert event, Emitter<CallDeviationState> emit) async {
    emit(state.copyWith(message: CallDeviationError.none));
  }

  // TODO: RESET ALERT
}
