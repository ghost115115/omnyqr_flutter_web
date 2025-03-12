import 'package:omnyqr/models/utility.dart';

class Association {
  final bool? isRealAssociation;
  final String? owner;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? associationType;
  final List<Utility>? utilities;
  final String? id;
  final String? uid;
  final bool? amIOwner;

  const Association(
      {this.isRealAssociation,
      this.owner,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.associationType,
      this.utilities,
      this.id,
      this.uid,
      this.amIOwner});

  Association.fromJson(Map<String, dynamic> json)
      : isRealAssociation = json['isRealAssociation'],
        owner = json['owner'],
        name = json['name'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        address = json['address'],
        associationType = json['associationType'],
        id = json['id'],
        uid = json['uid'],
        utilities = List.from(json['utilities'])
            .map((e) => Utility.fromJson(e))
            .toList(),
        amIOwner = json['amIOwner'];
}
