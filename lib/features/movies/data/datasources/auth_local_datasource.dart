import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSessionId(String sessionId);
  Future<void> saveAccountId(String accountId);
  Future<String?> getSessionId();
  Future<String?> getAccountId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  static const String _sessionIdKey = 'tmdb_session_id';
  static const String _accountIdKey = 'tmdb_account_id';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveSessionId(String sessionId) async {
    await prefs.setString(_sessionIdKey, sessionId);
  }

  @override
  Future<void> saveAccountId(String accountId) async {
    await prefs.setString(_accountIdKey, accountId);
  }

  @override
  Future<String?> getSessionId() async {
    return prefs.getString(_sessionIdKey);
  }

  @override
  Future<String?> getAccountId() async {
    return prefs.getString(_accountIdKey);
  }
}
