part of 'change_password_bloc.dart';

enum PasswordStatus { init, success, error, networkError, invalidCredential }

class ChangePasswordState extends Equatable {
  final bool showOldPassword;
  final bool showNewPassword;
  final bool showRepeatPassword;
  final PasswordStatus? status;
  //
  final String? oldPassword;
  final String? newPassword;
  final String? confirmPassword;
  final bool? isLoading;
  const ChangePasswordState(
      {this.showOldPassword = false,
      this.showNewPassword = false,
      this.showRepeatPassword = false,
      this.status = PasswordStatus.init,
      this.isLoading = false,
      this.oldPassword,
      this.confirmPassword,
      this.newPassword});

  ChangePasswordState copyWith(
      {bool? showOldPassword,
      bool? showNewPassword,
      bool? showRepeatPassword,
      PasswordStatus? status,
      String? newPassword,
      String? oldPassword,
      bool? isLoading,
      String? confirmPassword}) {
    return ChangePasswordState(
        showOldPassword: showOldPassword ?? this.showOldPassword,
        showNewPassword: showNewPassword ?? this.showNewPassword,
        showRepeatPassword: showRepeatPassword ?? this.showRepeatPassword,
        status: status ?? this.status,
        newPassword: newPassword ?? this.newPassword,
        oldPassword: oldPassword ?? this.oldPassword,
        isLoading: isLoading ?? this.isLoading,
        confirmPassword: confirmPassword ?? this.confirmPassword);
  }

  @override
  List<Object?> get props => [
        showOldPassword,
        showNewPassword,
        showRepeatPassword,
        status,
        newPassword,
        oldPassword,
        confirmPassword,
        isLoading
      ];
}

class ChangePasswordInitial extends ChangePasswordState {}
