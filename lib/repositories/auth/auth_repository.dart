import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import 'package:omnyqr/models/base_response.dart';
import 'package:omnyqr/models/login_response.dart';
import 'package:omnyqr/models/register_obj.dart';
import '../../clients/auth/auth_api_client.dart';
import '../../commons/utils/api_response.dart';

class AuthRepository {
  late final AuthApiClient _authClient;
  AuthRepository(this._authClient);

  Future<ApiResponse<LoginResponse?>> loginUser(
      String email, String password) async {
    try {
      final response = await _authClient.loginUser(email, password);

      if (response.isSuccess) {
  
        LoginResponse atResponse =
            LoginResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.success, atResponse, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<LoginResponse?>> register(RegisterObj registerObj) async {
    try {
      final response = await _authClient.registerUser(registerObj);
      if (response.isSuccess) {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        if (baseRespo.errorCode == null) {
          LoginResponse atResponse =
              LoginResponse.fromJson(jsonDecode(response.data ?? ""));
          return ApiResponse(ResponseState.success, atResponse, null);
        } else {
          BaseResponse baseRespo =
              BaseResponse.fromJson(jsonDecode(response.data ?? ""));
          return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
        }
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<void>> pswdReset(String email) async {
    try {
      final response = await _authClient.pswReset(email);
      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, null, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }
}
