import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import 'package:omnyqr/repositories/user/user_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final PreferencesRepo preferencesRepo;
  final UserRepository userRepository;
  AuthenticationBloc(this.preferencesRepo, this.userRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationInitEvent>(_initAuth);
    on<AuthenticationLoggedEvent>(_onUserAuth);
    on<AuthenticationLogoutEvent>(_onUserLogout);
  }

  void _initAuth(
      AuthenticationInitEvent event, Emitter<AuthenticationState> emit) async {
    await _checkUserAuth(emit);
  }

  void _onUserAuth(AuthenticationLoggedEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationLogged());
  }

  void _onUserLogout(
      AuthenticationLogoutEvent event, Emitter<AuthenticationState> emit) {
    emit(const AuthenticationAnonimous());
  }

  Future<void> _checkUserAuth(
    Emitter<AuthenticationState> emit,
  ) async {
    String? token = await preferencesRepo.getAccessToken();
    User? user = await preferencesRepo.getUser();
    String? refreshToken = await preferencesRepo.getRefreshToken();
    if (token != null && user != null && refreshToken != null) {
      emit(const AuthenticationLogged());
    } else {
      emit(const AuthenticationAnonimous());
    }
  }
}
