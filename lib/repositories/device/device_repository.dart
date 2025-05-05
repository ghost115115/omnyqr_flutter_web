import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:omnyqr/clients/device/device_api_client.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import 'package:omnyqr/models/base_response.dart';
import '../../commons/utils/api_response.dart';

class DeviceRepository {
  late final DeviceApiClient _deviceApiClient;
  DeviceRepository(this._deviceApiClient);


  Future<ApiResponse<String?>> registerFcmToken(
    String fcmToken,
    String apnToken,
  ) async {
    try {
      String id = '';
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (kIsWeb) {
        id = 'web-browser-${DateTime.now().millisecondsSinceEpoch}';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        id = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        id = iosDeviceInfo.identifierForVendor ?? '';
      }

      final response = await _deviceApiClient.registerFcmToken(
        fcmToken,
        apnToken,
        id,
      );
      if (response.isSuccess) {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        if (baseRespo.errorCode == null) {
          return ApiResponse(ResponseState.success, null, null);
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
}
