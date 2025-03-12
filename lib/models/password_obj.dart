class PassWordObj {
  final String? oldPassword;
  final String? newPassword;

  const PassWordObj(this.oldPassword, this.newPassword);

  Map<String, dynamic> toMap() {
    return {
      "oldPassword": oldPassword,
      'newPassword': newPassword,
    };
  }
}
