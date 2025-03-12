class RegisterObj {
  final String? email;
  final String? password;
  final String? name;
  final String? surname;
  final bool? isAssociationAdmin;
  final String? vat;
  final String? professionalEnrollment;

  RegisterObj(
      {this.email,
      this.isAssociationAdmin,
      this.name,
      this.password,
      this.professionalEnrollment,
      this.surname,
      this.vat});

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      'password': password,
      'name': name,
      'surname': surname,
      'isAssociationAdmin': isAssociationAdmin,
      'vat': vat,
      'professionalEnrollment': professionalEnrollment
    };
  }
}
