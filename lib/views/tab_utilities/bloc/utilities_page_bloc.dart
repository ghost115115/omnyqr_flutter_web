import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
part 'utilities_page_event.dart';
part 'utilities_page_state.dart';

class UtilitiesPageBloc extends Bloc<UtilitiesPageEvent, UtilitiesPageState> {
  final UtilityRepository utilityRepository;
  UtilitiesPageBloc(this.utilityRepository) : super(UtilitiesPageInitial()) {
    on<UtilitiesInitEvent>(_onInit);
  }

  _onInit(UtilitiesInitEvent event, Emitter<UtilitiesPageState> emit) async {
  }
}
