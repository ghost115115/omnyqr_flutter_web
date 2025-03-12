import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/repositories/search/search_repository.dart';
import '../../../commons/utils/api_response.dart';
import '../../../models/user.dart';
part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchRepository searchrepository;
  UserSearchBloc(
    this.searchrepository,
  ) : super(UserSearchInitial()) {
    on<UserSearchInitEvent>(_onInit);
    on<OnFieldChangveEvemt>(_onFieldChange);
    on<OnSearchSendEvent>(_onSendSearch);
    on<ResetSearchStatus>(_onReset);
  }
  _onInit(UserSearchInitEvent event, Emitter<UserSearchState> emit) {}

  _onFieldChange(OnFieldChangveEvemt event, Emitter<UserSearchState> emit) {
    emit(state.copyWith(name: event.value));
  }

  _onSendSearch(OnSearchSendEvent event, Emitter<UserSearchState> emit) async {
    emit(state.copyWith(isLoading: true));
    ApiResponse<UsersResponse?> response =
        await searchrepository.getUsers(state.name ?? '');
    if (response.isSuccess) {
      emit(state.copyWith(users: response.value?.users, isLoading: false));
    } else {
      // here we handle the exeptions

      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(
              status: UserSearchStatus.networkError, isLoading: false));
          break;

        default:
          emit(
              state.copyWith(status: UserSearchStatus.error, isLoading: false));
      }
    }
  }

  _onReset(ResetSearchStatus event, Emitter<UserSearchState> emit) {
    emit(state.copyWith(status: UserSearchStatus.init));
  }
}
