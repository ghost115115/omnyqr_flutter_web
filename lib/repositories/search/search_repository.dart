import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:omnyqr/clients/search/search_api_client.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import '../../commons/utils/api_response.dart';
import '../../models/base_response.dart';
import '../../models/user.dart';

class SearchRepository {
  late final SearchApiClient _searchApiClient;
  SearchRepository(this._searchApiClient);

Future<ApiResponse<UsersResponse?>>getUsers(String value) async {
    try {
      final response = await _searchApiClient.getUsers(value);

      if (response.isSuccess) {
        UsersResponse users =
            UsersResponse.fromJson(jsonDecode(response.data ?? ""));

        return ApiResponse(ResponseState.success, users, null);
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
