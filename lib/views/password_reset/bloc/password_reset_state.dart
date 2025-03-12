part of 'password_reset_bloc.dart';

enum SendResetStatus {
  init,
  success,
  error,
  networkError,
  wrongEmail,
  notFound
}

class PasswordResetState extends Equatable {
  final String? email;
  final SendResetStatus? status;
  final bool? isLoading;
  const PasswordResetState({this.status, this.email, this.isLoading = false});

  PasswordResetState copyWith(
      {SendResetStatus? status, String? email, bool? isLoading}) {
    return PasswordResetState(
        status: status ?? this.status,
        email: email ?? this.email,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [status, email, isLoading];
}

class PasswordResetInitial extends PasswordResetState {}
