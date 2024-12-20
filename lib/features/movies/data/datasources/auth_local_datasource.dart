abstract class AuthLocalDataSource {
  Future<void> saveSessionId(String sessionId);
  Future<void> saveAccountId(String accountId);
  Future<String?> getSessionId();
  Future<String?> getAccountId();
}
