// ignore_for_file: must_be_immutable

part of 'login_bloc.dart';

enum LoginStatus {
  init,
  authWrongCrendential,
  authenticationError,
  authenticated,
  networkError,
  accountNotActive,
  accountDisabled
}

class LoginState extends Equatable {
  final bool showPassword;
  String? password;
  String? email;
  LoginStatus? status;
  final bool? isLoading;
  LoginState(
      {this.showPassword = false,
      this.password,
      this.email,
      this.status = LoginStatus.init,
      this.isLoading = false});

  LoginState copyWith(
      {bool? showPassword,
      String? password,
      String? email,
      LoginStatus? status,
      bool? isLoading}) {
    return LoginState(
        showPassword: showPassword ?? this.showPassword,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [showPassword, password, email, status, isLoading];
}

class LoginInitial extends LoginState {}
