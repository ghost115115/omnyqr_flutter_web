import 'package:dio/dio.dart';
import 'package:omnyqr/clients/base_auth_api.dart';
import 'package:omnyqr/commons/constants/omny_urls.dart';
import 'package:omnyqr/extensions/dio_extension.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';

class DeviceApiClient extends BaseAuthApi {
  DeviceApiClient(PreferencesRepo prefRepo)
      : super(prefRepo, Urls.refreshToken);

  Future<Response<String?>> registerFcmToken(
    String fcmToken,
    String apnToken,
    String deviceId,
  ) async {
    return makeAuthCall(
      () {
        return client.responsePost<String>(
          Urls.registerFcmToken,
          {
            'fcmtoken': fcmToken,
            'apntoken': apnToken,
            'deviceId': deviceId,
          },
        );
      },
    );
  }
}
