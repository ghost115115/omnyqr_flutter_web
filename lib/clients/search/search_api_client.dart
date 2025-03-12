import 'package:dio/dio.dart';
import 'package:omnyqr/extensions/dio_extension.dart';

import '../../commons/constants/omny_urls.dart';
import '../../repositories/preferences/preferences_repo.dart';
import '../base_auth_api.dart';

class SearchApiClient extends BaseAuthApi {
  SearchApiClient(PreferencesRepo prefRepo)
      : super(prefRepo, Urls.refreshToken);

  String? accessToken;

  Future<Response<String?>> getUsers(String value) async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.users, {'filter': value},null);
    });
  }
}