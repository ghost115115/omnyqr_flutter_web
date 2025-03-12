class UtilityUnavailability {
  final String? associationId;
  final String? utilityId;
  final String? name;
  bool? isUnavailable;
  bool? hasBackupReferent;

  UtilityUnavailability({
    this.associationId,
    this.utilityId,
    this.name,
    this.isUnavailable,
    this.hasBackupReferent,
  });

  UtilityUnavailability.fromJson(Map<String, dynamic> json)
      : associationId = json["associationId"],
        utilityId = json["utilityId"],
        name = json["name"],
        isUnavailable = json["isUnavailable"],
        hasBackupReferent = json["hasBackupReferent"];

  Map<String, dynamic> toJson() {
    return {
      "associationId": associationId,
      "utilityId": utilityId,
      "name": name,
      "isUnavailable": isUnavailable,
      "hasBackupReferent": hasBackupReferent,
    };
  }
}
