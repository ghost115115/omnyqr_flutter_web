part of 'authentication_bloc.dart';

enum AuthState { logged, anonimous, initialising }

class AuthenticationState extends Equatable {
  final AuthState? state;
  const AuthenticationState({
    this.state = AuthState.anonimous,
  });
  AuthenticationState copyWith(AuthState? state) {
    return AuthenticationState(state: state ?? this.state);
  }

  @override
  List<Object?> get props => [state];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLogged extends AuthenticationState {
  const AuthenticationLogged()
      : super(
          state: AuthState.logged,
        );
}

class AuthenticationAnonimous extends AuthenticationState {
  const AuthenticationAnonimous()
      : super(
          state: AuthState.anonimous,
        );
}
