import 'package:shared_preferences/shared_preferences.dart';

class SharedData {

  static const _userUUID = 'user_uuid';
  static const _username = 'username';

  Future<void> saveUUID(String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUID, uuid);
  }

  Future<void> saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_username, username);
  }

  Future<String?> getUserUuid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUUID);
  }

  // Get Username
  Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_username);
  }
}