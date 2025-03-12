import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:omnyqr/extensions/dio_extension.dart';
import 'package:omnyqr/models/register_obj.dart';

import '../../commons/constants/omny_urls.dart';

class AuthApiClient {
  late final Dio _client;
  String? accessToken;

  AuthApiClient() {
    _client = Dio();
    _client.interceptors.add(
      AwesomeDioInterceptor(),
    );
  }

  Future<Response<String?>> loginUser(String email, String password) async {
    return await _client.responsePost<String>(
        Urls.login, {'email': email, 'password': password});
  }

  Future<Response<String?>> registerUser(RegisterObj registerObj) async {
    return await _client.responsePost<String>(
        Urls.register, registerObj.toMap());
  }

  Future<Response<String?>> pswReset(String email) async {
    return await _client.responsePost<String>(Urls.pswdReset, {'email': email});
  }
}
