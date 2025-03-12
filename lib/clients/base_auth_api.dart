import 'dart:convert';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:omnyqr/extensions/dio_extension.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import '../repositories/preferences/access_token_api.dart';
import 'dart:io';

abstract class BaseAuthApi {
  final AccessTokenApi _prefRepo;
  final String _refreshTokenUrl;
  late final Dio client;

  BaseAuthApi(
    this._prefRepo,
    this._refreshTokenUrl,
  ) {
    client = Dio();
    client.interceptors.add(AwesomeDioInterceptor());
    _initDio();
  }

  _initDio() async {
    client.addBearerToHeaders(await _prefRepo.getAccessToken());
  }

  Future<Response<T>> makeAuthCall<T>(
      Future<Response<T>> Function() apiCall) async {
    client.addBearerToHeaders(await _prefRepo.getAccessToken());
    var response = await apiCall.call();

    if (response.statusCode == 401) {
      var lastRefreshToken = await _prefRepo.getRefreshToken();

      if (lastRefreshToken?.isNotEmpty ?? false) {
        final refresh = await client.post<String>(_refreshTokenUrl,
            data: {"refreshToken": lastRefreshToken});

        if (refresh.isSuccess) {
          Map<String, dynamic> resObj = jsonDecode(refresh.data ?? '');
          final newToken = resObj["access"]["token"] as String?;
          final newRefreshToken = resObj["refresh"]["token"] as String?;

          if (newToken != null) {
            /*
           * Save token and call again
           */
            _prefRepo.saveToken(newToken);
            _prefRepo.saveRefreshToken(newRefreshToken);
            client.addBearerToHeaders(newToken);
            var response = await apiCall.call();
            return response;
          }
        }
      }
    } else {
      return response;
    }
    return response;
  }
}

class MYHttpOvverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
