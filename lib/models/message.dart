class Message {
  final String? id;
  final String? userId;
  final String? fullName;
  final String? date;
  final String? text;
  final bool? isCounterpart;
  final String? actionType;
  final bool? isActionDone;
  final MetaInfo? metadata;

  Message(
      {this.actionType,
      this.date,
      this.fullName,
      this.id,
      this.isActionDone,
      this.isCounterpart,
      this.text,
      this.userId,
      this.metadata});

  Message.fromJson(Map<String, dynamic> json)
      : actionType = json['actionType'],
        date = json['date'],
        fullName = json['fullName'],
        id = json['id'],
        isActionDone = json['isActionDone'],
        isCounterpart = json['isCounterpart'],
        text = json['text'],
        userId = json['userId'],
        metadata = MetaInfo.fromJson(json['metadata']);
}

class MetaInfo {
  final String? associationId;
  final String? utilityId;
  const MetaInfo({this.associationId, this.utilityId});
  MetaInfo.fromJson(Map<String, dynamic> json)
      : associationId = json['associationId'],
        utilityId = json['utilityId'];
}
