import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  // Keys for shared preferences
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';
  static const String _userPassKey = 'userPass';
  static const String _userRole = 'userPass';
  // Add more keys as needed

  // Shared preferences instance
  SharedPreferences? _prefs;

  // Initialize shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Check if the user is logged in
  bool get isLoggedIn {
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }

  // Get user ID
  String? get userId {
    return _prefs!.getString(_userIdKey);
  }

  // Get user name
  String? get userName {
    return _prefs!.getString(_userNameKey);
  }  String? get userEmail {
    return _prefs!.getString(_userEmailKey);
  }  String? get userPass {
    return _prefs!.getString(_userPassKey);
  } String? get userRole {
    return _prefs!.getString(_userRole);
  }

  // Login
  Future<void> login(String userId, String userName, String userEmail, String userPass,String userRole) async {
    await _prefs!.setBool(_isLoggedInKey, true);
    await _prefs!.setString(_userIdKey, userId);
    await _prefs!.setString(_userEmailKey, userEmail);
    await _prefs!.setString(_userPassKey, userPass);
    await _prefs!.setString(_userNameKey, userName);
    await _prefs!.setString(_userRole, userRole);
    // Add more data if needed
  }

  // Logout
  Future<void> logout() async {
    await _prefs!.setBool(_isLoggedInKey, false);
    await _prefs!.remove(_userIdKey);
    await _prefs!.remove(_userNameKey);
    await _prefs!.remove(_userEmailKey);
    await _prefs!.remove(_userPassKey);
    await _prefs!.remove(_userRole);
    // Clear more data if needed
  }
}
