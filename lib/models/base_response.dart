class BaseResponse {
  final String? errorCode;
  BaseResponse({this.errorCode});

  BaseResponse.fromJson(Map<String, dynamic> json) : errorCode = json['errorCode'];
}
