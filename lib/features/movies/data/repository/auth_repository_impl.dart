// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/presentation/widgets/auth_web_view.dart';

@injectable
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final AuthStateManager authStateManager;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authStateManager,
  });

  @override
  Future<Either<AppException, AuthEntity>> generateSessionId(
      {required BuildContext context}) async {
    try {
      // Step 1: Get request token
      final requestToken = await remoteDataSource.getRequestToken();

      // Step 2: Direct user to TMDB auth page
      final isAuthorized = await _authorizeRequestToken(context, requestToken);
      if (!isAuthorized) {
        return Left(AppException('User did not authorize the token'));
      }

      // Step 3: Create session with authorized token
      final sessionId = await remoteDataSource.createSession(requestToken);
      if (sessionId == 'tmdb_session_id') {
        return Left(AppException('Failed to create session ID'));
      }

      // Step 4: Get account ID using session
      final accountId = await remoteDataSource.getAccountId(sessionId);
      if (accountId == 'tmdb_account_id') {
        return Left(AppException('Failed to fetch account ID'));
      }

      // Step 5: Save credentials
      await localDataSource.saveSessionId(sessionId);
      await localDataSource.saveAccountId(accountId);

      // Return AuthEntity with session and account info
      return Right(AuthEntity(
        sessionId: sessionId,
        accountId: accountId,
      ));
    } catch (e) {
      return Left(AppException('Failed to generate session: ${e.toString()}'));
    }
  }

  Future<bool> _authorizeRequestToken(
      BuildContext context, String requestToken) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AuthWebView(url: '${NetworkRoutes.authenticate}$requestToken'),
      ),
    );
  }

  @override
  Future<Either<AppException, String?>> getStoredSessionId() async {
    try {
      final sessionId = await localDataSource.getSessionId();
      return Right(sessionId);
    } catch (e) {
      return Left(AppException('Failed to get stored session ID'));
    }
  }

  @override
  Future<Either<AppException, String?>> getStoredAccountId() async {
    try {
      final accountId = await localDataSource.getAccountId();
      return Right(accountId);
    } catch (e) {
      return Left(AppException('Failed to get stored account ID'));
    }
  }
}
