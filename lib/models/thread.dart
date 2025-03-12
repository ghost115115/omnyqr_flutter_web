class Thread {
  final String? counterpartId;
  final String? counterpartName;
  final String? lastDate;
  final String? lastMessage;

  const Thread(
      {this.counterpartId,
      this.counterpartName,
      this.lastDate,
      this.lastMessage});

  Thread.fromJson(Map<String, dynamic> json)
      : counterpartId = json['counterpartId'],
        counterpartName = json['counterpartName'],
        lastDate = json['lastDate'],
        lastMessage = json['lastMessage'];
}
