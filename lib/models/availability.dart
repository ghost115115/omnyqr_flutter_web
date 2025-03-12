class Availability {
  bool? isActive;
  String? start;
  String? end;
  int? day;

  Availability({this.day, this.end, this.isActive, this.start});

  Availability.fromJson(Map<String, dynamic> json)
      : day = json['day'],
        end = json['end'],
        isActive = json['isActive'],
        start = json['start'];

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'end': end,
      'isActive': isActive,
      'start': start,
    };
  }
}
