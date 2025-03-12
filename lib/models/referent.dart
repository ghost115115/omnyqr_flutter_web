class Referent {
  final String? status;
  final String? user;
  final String? name;
  final String? surname;

  const Referent({this.status, this.user, this.name, this.surname});

  Referent.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        user = json['user'],
        name = json['name'],
        surname = json['surname'];

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      'user': user,
    };
  }
}
