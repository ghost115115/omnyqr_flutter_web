import 'package:omnyqr/models/referent.dart';

class Utility {
  final String? details;
  final String? utilityLink;
  final String? startDate;
  final String? endDate;
  final String? type;
  final String? intercomName;
  final String? address;
  final List<Referent>? referents;
  final String? id;
  final bool? isActive;
  final bool? isRealAssociation;
  final bool? canCall;
  final double? latitude;
  final double? longitude;
  final bool? isPrivate;

  final Referent? backupReferent;

  final List<String>? unavailableReferents;

  Utility({
    this.details,
    this.utilityLink,
    this.startDate,
    this.endDate,
    this.type,
    this.intercomName,
    this.address,
    this.referents,
    this.id,
    this.isActive,
    this.isRealAssociation,
    this.canCall,
    this.latitude,
    this.longitude,
    this.isPrivate,
    this.backupReferent,
    this.unavailableReferents,
  });

  Utility.fromJson(Map<String, dynamic> json)
      : details = json['details'],
        utilityLink = json['utilityLink'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        type = json['type'],
        intercomName = json['intercomName'],
        address = json['address'],
        isActive = json['isActive'],
        id = json['id'],
        referents = List.from(json['referents'])
            .map((e) => Referent.fromJson(e))
            .toList(),
        isRealAssociation = json['isRealAssociation'],
        canCall = json['canCall'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        isPrivate = json['isPrivate'],
        backupReferent = Referent.fromJson(json["backupReferent"] ?? {}),
        unavailableReferents = (json["unavailableReferents"] as List<dynamic>?)
            ?.cast<String>()
            .toList();

  Map<String, dynamic> toMap() {
    List referentsJson =
        referents?.map((referent) => referent.toJson()).toList() ?? [];

    return {
      "details": details,
      'utilityLink': utilityLink,
      'startDate': startDate,
      'endDate': endDate,
      'type': type,
      'intercomName': intercomName,
      'address': address,
      "associationId": id,
      'referents': referentsJson,
      'isRealAssociation': isRealAssociation,
      'latitude': latitude,
      'longitude': longitude,
      'isPrivate': isPrivate ?? false,
      "backupReferent": backupReferent?.user,
    };
  }

  Map<String, dynamic> updateToMap() {
    List referentsJson =
        referents?.map((referent) => referent.toJson()).toList() ?? [];

    return {
      "details": details,
      'utilityLink': utilityLink,
      'startDate': startDate,
      'endDate': endDate,
      'intercomName': intercomName,
      'address': address,
      "associationId": id,
      "isActive": isActive,
      'referents': referentsJson,
      'isRealAssociation': isRealAssociation,
      'latitude': latitude,
      'longitude': longitude,
      'isPrivate': isPrivate ?? false,
      "backupReferent": backupReferent?.user,
    };
  }
}
