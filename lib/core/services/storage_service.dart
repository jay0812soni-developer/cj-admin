import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = 'cj_admin_token';
  static const String _keyRole = 'cj_admin_role';
  static const String _keyUsername = 'cj_admin_username';
  static const String _keyDisplayName = 'cj_admin_display_name';

  static Future<void> saveAuth({
    required String token,
    required String role,
    required String username,
    required String displayName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyDisplayName, displayName);
  }

  static Future<Map<String, String?>> getAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(_keyToken),
      'role': prefs.getString(_keyRole),
      'username': prefs.getString(_keyUsername),
      'displayName': prefs.getString(_keyDisplayName),
    };
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyDisplayName);
  }
}
