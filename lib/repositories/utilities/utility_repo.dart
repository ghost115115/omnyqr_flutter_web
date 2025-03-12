import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:omnyqr/clients/utility/utility_api_client.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import 'package:omnyqr/models/associations.dart';
import 'package:omnyqr/models/availability.dart';
import 'package:omnyqr/models/base_response.dart';
import 'package:omnyqr/models/qr_obj.dart';
import 'package:omnyqr/models/referent.dart';
import 'package:omnyqr/models/utility.dart';
import 'package:omnyqr/models/utility_unavailability.dart';

class UtilityRepository {
  late final UtilityApiClient _utilityApiClient;
  UtilityRepository(this._utilityApiClient);

  Future<ApiResponse<List<Association>>> getUtilities() async {
    try {
      final response = await _utilityApiClient.getUtilities();
      List<Association>? associations;
      if (response.isSuccess) {
        List<dynamic> jsonList = jsonDecode(response.data ?? "");
        associations =
            jsonList.map((item) => Association.fromJson(item)).toList();

        return ApiResponse(ResponseState.success, associations, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<List<Association>>> sendUtility(Utility utility) async {
    try {
      final response = await _utilityApiClient.sendUtility(utility);

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

  Future<ApiResponse<List<Association>>> updateUtility(
      String associationId, String utilityId, Utility utility) async {
    try {
      final response = await _utilityApiClient.updateUtility(
          associationId, utilityId, utility);

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

  Future<ApiResponse<List<Association>>> sendUtilityForm(
      dynamic utility) async {
    try {
      final response = await _utilityApiClient.sendUtilityForm(utility);

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

  Future<ApiResponse<List<Association>>> updateUtilityFormData(
      String associationId, String utilityId, dynamic utility) async {
    try {
      final response = await _utilityApiClient.updateUtilityForm(
          associationId, utilityId, utility);

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

  Future<ApiResponse<List<Association>>> getMyAssociations() async {
    try {
      final response = await _utilityApiClient.getMyAssociations();
      List<Association>? associations;
      if (response.isSuccess) {
        List<dynamic> jsonList = jsonDecode(response.data ?? "");
        associations =
            jsonList.map((item) => Association.fromJson(item)).toList();

        return ApiResponse(ResponseState.success, associations, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<Association>> createAssociation(
      String name, String address, String type, double lat, double long) async {
    try {
      final response = await _utilityApiClient.createAssociation(
          name, address, type, lat, long);

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

  Future<ApiResponse<String>> deleteUtility(
      String associationId, String utilityId) async {
    try {
      final response = await _utilityApiClient.deleteUtility(
        associationId,
        utilityId,
      );

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

  Future<ApiResponse<String>> deleteUsers(
    String associationId,
    String utilityId,
  ) async {
    try {
      final response = await _utilityApiClient.deleteUsers(
        associationId,
        utilityId,
      );

      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, null, null);
      } else {
        BaseResponse baseResponse = BaseResponse.fromJson(
          jsonDecode(response.data ?? ""),
        );
        return ApiResponse(ResponseState.error, null, baseResponse.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<QrObj>> getQr(
    String associationId,
  ) async {
    try {
      final response = await _utilityApiClient.getQr(associationId);
      QrObj baseRespo = QrObj.fromJson(jsonDecode(response.data ?? ""));
      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, baseRespo, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<List<Availability>>> getAvailabilities(
    String utilityId,
  ) async {
    try {
      final response = await _utilityApiClient.getAvailabilities(utilityId);

      List<Availability>? associations;
      if (response.isSuccess) {
        List<dynamic> jsonList = jsonDecode(response.data ?? "");
        associations =
            jsonList.map((item) => Availability.fromJson(item)).toList();
        return ApiResponse(ResponseState.success, associations, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<List<Availability>>> updateAvailabilities(
      String utilityId, List<Availability> availabilities) async {
    try {
      final response = await _utilityApiClient.updateAvailabilities(
          utilityId, availabilities);

      List<Availability>? associations;
      if (response.isSuccess) {
        List<dynamic> jsonList = jsonDecode(response.data ?? "");
        associations =
            jsonList.map((item) => Availability.fromJson(item)).toList();
        return ApiResponse(ResponseState.success, associations, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<Association>> getAssociation(String associationId) async {
    try {
      final response = await _utilityApiClient.getAssociation(associationId);

      if (response.isSuccess) {
        Association association =
            Association.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.success, association, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));

        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<Utility>> updateOnOffUtility(String associationId,
      String utilityId, bool value, List<Referent> referents) async {
    try {
      final response = await _utilityApiClient.updateIsActive(
          associationId, utilityId, value, referents);

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

  Future<ApiResponse<Utility>> updateIsPrivate(String associationId,
      String utilityId, bool isPrivate, List<Referent> referents) async {
    try {
      final response = await _utilityApiClient.isPrivate(
          associationId, utilityId, isPrivate, referents);
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

  Future<ApiResponse<List<UtilityUnavailability>>>
      getUtilityUnavailability() async {
    try {
      final response = await _utilityApiClient.getUtilityUnavailability();
      if (response.isSuccess) {
        final data = jsonDecode(response.data ?? '');
        final List<UtilityUnavailability> utilitiesUnavailability =
            ((data["utilities"] ?? '') as List<dynamic>)
                .map((e) => UtilityUnavailability.fromJson(e))
                .toList();
        return ApiResponse(
            ResponseState.success, utilitiesUnavailability, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse> putUtilityUnavailability(
      List<UtilityUnavailability> utilitiesUnavailability) async {
    try {
      final Map<String, dynamic> json = {
        "utilities": utilitiesUnavailability.map((e) => e.toJson()).toList()
      };
      final response = await _utilityApiClient.putUtilityUnavailability(json);
      if (response.isSuccess) {
        return ApiResponse(
          ResponseState.success,
          null,
          null,
        );
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(
          ResponseState.error,
          null,
          baseRespo.errorCode,
        );
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }
}
