import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:omnyqr/clients/base_auth_api.dart';
import 'package:omnyqr/commons/constants/omny_urls.dart';
import 'package:omnyqr/extensions/dio_extension.dart';
import 'package:omnyqr/models/availability.dart';
import 'package:omnyqr/models/referent.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import '../../models/utility.dart';

class UtilityApiClient extends BaseAuthApi {
  UtilityApiClient(PreferencesRepo prefRepo)
      : super(prefRepo, Urls.refreshToken);

  String? accessToken;

  Future<Response<String?>> getUtilities() async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.utilities, null, null);
    });
  }

  Future<Response<String?>> sendUtility(Utility utility) async {
    return makeAuthCall(() {
      return client.responsePost<String>(Urls.sendUtility, utility.toMap());
    });
  }

  Future<Response<String?>> updateUtility(
      String associationId, String utilityId, Utility utility) async {
    return makeAuthCall(() {
      return client.responsePut<String>(
          Urls.deleteUtility(associationId, utilityId), utility.updateToMap());
    });
  }
  ////////////////

  Future<Response<String?>> sendUtilityForm(dynamic utility) async {
    return makeAuthCall(() {
      return client.responsePost<String>(Urls.sendUtility, utility);
    });
  }

  Future<Response<String?>> updateUtilityForm(
      String associationId, String utilityId, dynamic utility) async {
    return makeAuthCall(() {
      return client.responsePut<String>(
          Urls.deleteUtility(associationId, utilityId), utility);
    });
  }

  Future<Response<String?>> updateIsActive(String associationId,
      String utilityId, bool value, List<Referent> referents) async {
    return makeAuthCall(() {
      return client.responsePut<String>(
          Urls.deleteUtility(associationId, utilityId),
          {'isActive': value, "referents": referents});
    });
  }
  /////////////

  Future<Response<String?>> getMyAssociations() async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.myAssociations, null, null);
    });
  }

  Future<Response<String?>> createAssociation(
      String name, String address, String type, double lat, double long) async {
    return makeAuthCall(() {
      return client.responsePost<String>(Urls.createAssociation, {
        'name': name,
        'address': address,
        "associationType": type,
        "latitude": lat,
        "longitude": long
      });
    });
  }

  Future<Response<String?>> deleteUtility(
    String associationId,
    String utilityId,
  ) async {
    return makeAuthCall(() {
      return client.responseDel<String>(
          Urls.deleteUtility(associationId, utilityId), null);
    });
  }

  Future<Response<String?>> deleteUsers(
    String associationId,
    String utilityId,
  ) async {
    return makeAuthCall(() {
      return client.responseDel<String>(
        Urls.deleteUser(associationId, utilityId),
        null,
      );
    });
  }

  Future<Response<String?>> getQr(
    String associationId,
  ) async {
    return makeAuthCall(() {
      return client.responseGet<String>(Urls.getQr(associationId), null, null);
    });
  }

  Future<Response<String?>> getAvailabilities(
    String utilityId,
  ) async {
    return makeAuthCall(() {
      return client.responseGet<String>(
          Urls.getAvailabilities(utilityId), null, null);
    });
  }

  Future<Response<String?>> updateAvailabilities(
      String utilityId, List<Availability> availabilities) async {
    return makeAuthCall(() {
      return client.responsePut<String>(
          Urls.updateAvailabilities(utilityId), json.encode(availabilities));
    });
  }

  Future<Response<String?>> getAssociation(String associationId) async {
    return makeAuthCall(() {
      return client.responseGet<String>(
          Urls.getAssociation(associationId), null, null);
    });
  }

  Future<Response<String?>> isPrivate(String associationId, String utilityId,
      bool isPrivate, List<Referent> referents) async {
    return makeAuthCall(() {
      return client.responsePut<String>(
          Urls.deleteUtility(associationId, utilityId),
          {'isPrivate': isPrivate, "referents": referents});
    });
  }

  Future<Response<String?>> getUtilityUnavailability() async {
    return makeAuthCall(() {
      return client.responseGet<String>(
        Urls.utilityUnavailability,
        null,
        null,
      );
    });
  }

  Future<Response<String?>> putUtilityUnavailability(
      Map<String, dynamic> utilityUnavailability) async {
    return makeAuthCall(() {
      return client.responsePut<String>(
        Urls.utilityUnavailability,
        utilityUnavailability,
      );
    });
  }
}
