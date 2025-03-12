import 'package:dio/dio.dart';

extension ResponseExt on Response {
  bool get isSuccess => (statusCode ?? 0) <= 299 && (statusCode ?? 0) >= 200;
}
