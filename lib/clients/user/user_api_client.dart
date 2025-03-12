import 'package:dio/dio.dart';
import 'package:omnyqr/clients/base_auth_api.dart';
import 'package:omnyqr/commons/constants/omny_urls.dart';
import 'package:omnyqr/extensions/dio_extension.dart';
import 'package:omnyqr/models/password_obj.dart';
import 'package:omnyqr/models/purchase_model.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';

class UserApiClient extends BaseAuthApi {
  UserApiClient(PreferencesRepo prefRepo) : super(prefRepo, Urls.refreshToken);

  String? accessToken;

  Future<Response<String?>> updateUser(User user) async {
    return makeAuthCall(() {
      return client.responsePatch<String>(Urls.updateUser, user.updateToJson());
    });
  }


  Future<Response<String?>> passwordChange(PassWordObj obj) async {
    return makeAuthCall(() {
      return client.responsePatch<String>(Urls.passwordChange, obj.toMap());
    });
  }

    Future<Response<String?>> deleteAccount( ) async {
    return makeAuthCall(() {
      return client.responseDel<String>(Urls.updateUser,null);
    });
  }

    Future<Response<String?>> updateLvl(PurchaseModel lvl) async {
    return makeAuthCall(() {
      return client.responsePatch<String>(Urls.updateLvl, lvl.toMap());
    });
  }
  
    Future<Response<String?>> getMyData() async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.updateUser,null,null);
    });
  }
}