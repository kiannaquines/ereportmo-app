import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginData(String token, String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
  await prefs.setString('user_name', name);
}

Future<String?> getSecureToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}

Future<void> removeLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
  await prefs.remove('user_name');
}
