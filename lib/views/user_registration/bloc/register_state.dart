part of 'register_bloc.dart';

enum RegistrationStatus {
  init,
  success,
  error,
  networkError,
  emailAlreadyInUse
}

class RegisterState extends Equatable {
  final bool showPassword;
  final bool showConfirmPassword;
  final bool showAdminField;
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? vat;
  final String? professionalRegister;
  final RegistrationStatus? status;
  final bool? isLoading;
  const RegisterState(
      {this.showAdminField = false,
      this.showConfirmPassword = false,
      this.showPassword = false,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.confirmPassword,
      this.professionalRegister,
      this.status = RegistrationStatus.init,
      this.vat,
      this.isLoading = false});

  RegisterState copyWith(
      {bool? showPassword,
      bool? showConfirmPassword,
      bool? showAdminField,
      String? name,
      String? email,
      String? surname,
      String? password,
      String? confirmPassword,
      String? vat,
      String? professionalRegister,
      RegistrationStatus? status,
      bool? isLoading}) {
    return RegisterState(
        showAdminField: showAdminField ?? this.showAdminField,
        showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
        showPassword: showPassword ?? this.showPassword,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        vat: vat ?? this.vat,
        professionalRegister: professionalRegister,
        status: status ?? this.status,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [
        showAdminField,
        showPassword,
        showConfirmPassword,
        email,
        name,
        surname,
        password,
        confirmPassword,
        vat,
        professionalRegister,
        status,
        isLoading
      ];
}

class RegisterInitial extends RegisterState {}
