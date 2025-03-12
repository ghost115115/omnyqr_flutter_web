part of 'authentication_bloc.dart';

 class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}
class AuthenticationInitEvent extends AuthenticationEvent {}

class AuthenticationLoggedEvent extends AuthenticationEvent {}

class AuthenticationLogoutEvent extends AuthenticationEvent {}