import 'package:dio/dio.dart';
import 'package:omnyqr/clients/base_auth_api.dart';
import 'package:omnyqr/commons/constants/omny_urls.dart';
import 'package:omnyqr/extensions/dio_extension.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';

class MessageApiClient extends BaseAuthApi {
  MessageApiClient(PreferencesRepo prefRepo)
      : super(prefRepo, Urls.refreshToken);

  Future<Response<String?>> getThreads() async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.getThreds, null, null);
    });
  }

  Future<Response<String?>> getMessages(String id) async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.getMessages(id), null, null);
    });
  }

  Future<Response<String?>> sendMessage(String id, String message) async {
    return makeAuthCall(() {
      return client.responsePost<String>(
          Urls.sendMessage(id), {"actionType": 'MESSAGE', "text": message});
    });
  }

  Future<Response<String?>> acceptInvitation(String id, bool value) async {
    return makeAuthCall(() {
      return client.responsePatch<String>(
          Urls.acceptInvitation(id), {"hasAcceptedInvitation": value});
    });
  }

  Future<Response<String?>> sendPush(
      String id, String type, String name) async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.sendPush, null,
          {"calleeId": id, "notifType": type, "utilityName": name});
    });
  }
}
