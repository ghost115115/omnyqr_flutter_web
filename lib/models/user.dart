class User {
  final String? role;
  final bool? isVerified;
  final bool? isAdmin;
  final bool? enabled;
  final String? vat;
  final String? professionalEnrollment;
  final String? email;
  final String? name;
  final String? surname;
  final String? id;
  final String? uid;
  final String? premiumStatus;
  final bool? isIncognito;
  String? status;

  User(
      {this.status,
      this.role,
      this.isVerified,
      this.isAdmin,
      this.vat,
      this.professionalEnrollment,
      this.email,
      this.name,
      this.surname,
      this.id,
      this.uid,
      this.premiumStatus,
      this.enabled,
      this.isIncognito});

  User.fromJson(Map<String, dynamic> json)
      : role = json['role'],
        isVerified = json['isEmailVerified'],
        isAdmin = json['isAssociationAdmin'],
        vat = json['vat'],
        professionalEnrollment = json['professionalEnrollment'],
        email = json['email'],
        name = json['name'],
        surname = json['surname'],
        id = json['id'],
        uid = json['uid'],
        premiumStatus = json['premiumStatus'],
        enabled = json['enabled'],
        isIncognito = json['isIncognito'];

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'isEmailVerified': isVerified,
      'isAssociationAdmin': isAdmin,
      'vat': vat,
      'professionalEnrollment': professionalEnrollment,
      'email': email,
      'name': name,
      'surname': surname,
      'id': id,
      'uid': uid,
      'premiumStatus': premiumStatus
    };
  }

  Map<String, dynamic> updateToJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'isIncognito': isIncognito
    };
  }
}

class UsersResponse {
  final List<User>? users;
  const UsersResponse({this.users});

  UsersResponse.fromJson(Map<String, dynamic> json)
      : users =
            List.from(json['results']).map((e) => User.fromJson(e)).toList();
}
