import 'package:shared_preferences/shared_preferences.dart';

class SharedData {

  static const _userUUID = 'user_uuid';
  static const _username = 'username';

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