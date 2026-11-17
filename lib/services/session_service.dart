import 'package:shared_preferences/shared_preferences.dart'; //nyimpen shared preferences

class SessionService {
  static const _keyUsername = 'username';

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username); //nyimpen username ke shared preferences
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername); //baca username dari shared preferences
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername); //buat hapus, dipake pas logout
  }
}
