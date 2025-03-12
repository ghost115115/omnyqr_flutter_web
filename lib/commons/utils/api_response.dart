enum ResponseState {
  success,
  error,
  maintenance,
}

class ApiResponse<T> {
  ResponseState? state;
  T? value;
  String? message;

  ApiResponse(this.state, this.value, this.message);

  bool get isSuccess => state == ResponseState.success;
}
