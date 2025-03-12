import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:omnyqr/clients/user/user_api_client.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import 'package:omnyqr/models/base_response.dart';
import 'package:omnyqr/models/password_obj.dart';
import 'package:omnyqr/models/purchase_model.dart';
import 'package:omnyqr/models/user.dart';

class UserRepository {
  late final UserApiClient _userApiClient;
  UserRepository(this._userApiClient);

  Future<ApiResponse<User>> upDateUser(User user) async {
    try {
      final response = await _userApiClient.updateUser(user);
      User newUser = User.fromJson(jsonDecode(response.data ?? ""));

      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, newUser, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<User>> changePassword(PassWordObj obj) async {
    try {
      final response = await _userApiClient.passwordChange(obj);

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

  Future<ApiResponse<User>> deleteAccount() async {
    try {
      final response = await _userApiClient.deleteAccount();

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

  Future<ApiResponse<User>> upDateUserLvl(PurchaseModel lvl) async {
    try {
      final response = await _userApiClient.updateLvl(lvl);
      User newUser = User.fromJson(jsonDecode(response.data ?? ""));

      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, newUser, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<User>> getMyData() async {
    try {
      final response = await _userApiClient.getMyData();
      User newUser = User.fromJson(jsonDecode(response.data ?? ""));

      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, newUser, null);
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
