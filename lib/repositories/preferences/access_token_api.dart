abstract class AccessTokenApi {
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();
  Future<bool> saveToken(String? token);

  // Refresh token
  Future<String>? getRefreshToken();
  Future<void> deleteRefreshToken();
  Future<bool> saveRefreshToken(String? token);
}
