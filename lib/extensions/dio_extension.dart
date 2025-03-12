import 'dart:io';
import 'package:dio/dio.dart';

extension DioExt on Dio {
  void addBearerToHeaders(String? token) {
    options.headers.addAll(getAuthHeaders(token));
  }

  Map<String, String> getAuthHeaders(String? accessToken) {
    return {HttpHeaders.authorizationHeader: "Bearer $accessToken",};
  }

  Future<Response<T>> responseGet<T>(String? url, queryParameters,data) async {
    return await get(
      url ?? '',
      queryParameters: queryParameters ?? {},
      data: data ?? {},
      options: Options(
        responseType: ResponseType.json,
        validateStatus: (statusCode) {
          if (statusCode == 200) {
            return true;
          }

          return true;
        },
      ),
    );
  }

  Future<Response<T>> responsePut<T>(String? url, data) {
    return put(
      url ?? '',
      data: data ?? {},
      options: Options(
        responseType: ResponseType.json,
        validateStatus: (statusCode) {
          if (statusCode == 200) {
            return true;
          }

          return true;
        },
      ),
    );
  }

  Future<Response<T>> responsePost<T>(String? url, data) {
    return post(
      url ?? '',
      data: data ?? {},
      options: Options(
        responseType: ResponseType.json,
        validateStatus: (statusCode) {
          if (statusCode == 200) {
            return true;
          }

          return true;
        },
      ),
    );
  }

  Future<Response<T>> responseDel<T>(String? url, data) async {
    return await delete(
      url ?? '',
      data: data ?? {},
      options: Options(
        responseType: ResponseType.json,
        validateStatus: (statusCode) {
          if (statusCode == 200) {
            return true;
          }

          return false;
        },
      ),
    );
  }

  Future<Response<T>> responsePatch<T>(String? url, data) async {
    return await patch(
      url ?? '',
      data: data ?? {},
      options: Options(
        responseType: ResponseType.json,
        validateStatus: (statusCode) {
          if (statusCode == 200) {
            return true;
          }

          return false;
        },
      ),
    );
  }
}
