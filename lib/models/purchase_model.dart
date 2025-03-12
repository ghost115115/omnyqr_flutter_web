class PurchaseModel {
  final String? premiumStatus;
  final PurchaseData? purchaseData;
  const PurchaseModel(this.premiumStatus,this.purchaseData);
    Map<String, dynamic> toMap() {
    return {"premiumStatus": premiumStatus, 'purchaseData': purchaseData?.toMap(), };
  }
}

/**
 * {
  "premiumStatus": "enterprise",
  "purchaseData": {
    "productId": "level_enterprise", 
    "token": "odehocemcijdeoodndoeheig.AO-J1OwEbZXrMhxIACDAbQguPVj9L7PLpBjyOrDa_wkGqZvln8gowzEzVcBwfkiomQRShK5AygTHcF5mDOojX7cfQIZ2M8f6BA",
    "source": "google_play"
  }
}
 */

class PurchaseData {
  final String? productId;
  final String? token;
  final String? source;

  const PurchaseData(this.productId, this.token, this.source);

  Map<String, dynamic> toMap() {
    return {"productId": productId, 'token': token, 'source': source};
  }
}
