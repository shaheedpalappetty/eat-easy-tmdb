import 'dart:async';

class AuthStateManager {
  final _authController = StreamController<bool>.broadcast();

  Stream<bool> get authStateStream => _authController.stream;

  void updateAuthState(bool isAuthorized) {
    _authController.add(isAuthorized);
  }

  void dispose() {
    _authController.close();
  }
}
