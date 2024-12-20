abstract class AuthRemoteDataSource {
  Future<String> getRequestToken();
  Future<String> createSession(String requestToken);
  Future<String> getAccountId(String sessionId);
}
