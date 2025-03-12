class QrObj {
  final String? qrCodeDataURL;
  const QrObj({this.qrCodeDataURL});

  QrObj.fromJson(Map<String, dynamic> json)
      : qrCodeDataURL = json['qrCodeDataURL'];
}
