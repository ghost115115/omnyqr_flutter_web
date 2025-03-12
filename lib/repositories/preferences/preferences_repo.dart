import 'dart:convert';

import 'package:omnyqr/repositories/preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import 'access_token_api.dart';

class PreferencesRepo extends AccessTokenApi {
  Future<bool> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
  // ACCESS TOKEN

  @override
  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Preferences.accessToken);
  }

  @override
  Future<void> deleteAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Preferences.accessToken);
  }

  @override
  Future<bool> saveToken(String? token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Preferences.accessToken, token ?? '');
  }

  // REFRESH TOKEN

  @override
  Future<String>? getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Preferences.refreshToken) ?? '';
  }

  @override
  Future<bool> saveRefreshToken(String? token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Preferences.refreshToken, token ?? '');
  }

  @override
  Future<void> deleteRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Preferences.refreshToken);
  }

  Future<bool> saveUser(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user?.toJson());
    return prefs.setString(Preferences.user, userJson);
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(Preferences.user);
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Preferences.user);
  }

  Future<bool> saveCallKit(bool? isCallKit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(Preferences.isCallKit, isCallKit ?? false);
  }

  Future<bool?> getCallKit() async {
    @override
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Preferences.isCallKit);
  }

  Future<void> deleteCallKit() async {
    @override
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Preferences.isCallKit);
  }
}
