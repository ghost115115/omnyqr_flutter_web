import 'package:flutter_dotenv/flutter_dotenv.dart';

class Urls {
  static final apiUrl = dotenv.env["API_URL"];

  // Login
  static String get login => "${apiUrl}v1/auth/login";
  // Register
  static String get register => "${apiUrl}v1/auth/register";
  // get  utilities
  static String get utilities => "${apiUrl}v1/associations/my-ref";
  // refresh
  static String get refreshToken => "${apiUrl}v1/auth/refresh-tokens";
  // get Users
  static String get users => "${apiUrl}v1/users/";
  // utilities
  static String get sendUtility => "${apiUrl}v1/utilities";
  // associations
  static String get myAssociations => "${apiUrl}v1/associations/my";
  // create association
  static String get createAssociation => "${apiUrl}v1/associations";
  // update / delete

  static String deleteUtility(String associationId, String utilityId) =>
      "${apiUrl}v1/utilities/$associationId/$utilityId";
  // updateUser
  static String get updateUser => "${apiUrl}v1/users/my";
  // passwordChange
  static String get passwordChange => "${apiUrl}v1/users/my/credentials";
  // get Threds
  static String get getThreds => "${apiUrl}v1/messages";

  static String getMessages(String id) => "${apiUrl}v1/messages/$id";
  static String sendMessage(String id) => "${apiUrl}v1/messages/$id";
  static String acceptInvitation(String id) =>
      "${apiUrl}v1/messages/$id/action-status";

  static String getQr(String id) => "${apiUrl}v1/associations/$id/qr-code";

  static String getAvailabilities(String id) =>
      "${apiUrl}v1/utilities/$id/availabilities";

  static String updateAvailabilities(String id) =>
      "${apiUrl}v1/utilities/$id/availabilities";

  static String getAssociation(String id) => "${apiUrl}v1/associations/$id";

  static String get updateLvl => "${apiUrl}v1/iap/status";

  static String get registerFcmToken => "${apiUrl}v1/fcm";

  static String get sendPush => "${apiUrl}v1/fcm/call";

  static String get pswdReset => "${apiUrl}v1/auth/forgot-password";

  static String deleteUser(String associationId, String utilityId) =>
      "${apiUrl}v1/users/$associationId/$utilityId";

  static String get utilityUnavailability =>
      "${apiUrl}v1/utilities/unavailability";
}
