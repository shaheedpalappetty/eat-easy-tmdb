// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:eat_easy_assignment/core/exceptions/app_exception.dart';
import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_local_datasource.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_remote_datasource.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_state_manager.dart';
import 'package:eat_easy_assignment/features/movies/domain/auth_repository.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/auth_entity.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

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
      if (sessionId == null) {
        return Left(AppException('Failed to create session ID'));
      }

      // Step 4: Get account ID using session
      final accountId = await remoteDataSource.getAccountId(sessionId);
      if (accountId == null) {
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
    try {
      final String url =
          'https://www.themoviedb.org/authenticate/$requestToken';

      // Create a Completer to wait for the result
      final Completer<bool> completer = Completer<bool>();

      // Create the WebView and navigate to it
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text("Authenticate")),
            body: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
              onLoadStop: (controller, url) async {
                Logger.log("OnPageLoad", type: LogType.error);

                if (url != null && url.toString().contains('allow')) {
                  Logger.log("Autentication Approved", type: LogType.success);

                  completer.complete(true);
                  Navigator.pop(context); // Close the web view
                } else if (url != null && url.toString().contains('deny')) {
                  Logger.log("Autentication Denied", type: LogType.error);
                  completer.complete(false);
                  Navigator.pop(context); // Close the web view
                }
              },
              onLoadError: (controller, url, code, message) {
                Logger.log("onLoadError", type: LogType.error);

                completer.complete(false);
                Navigator.pop(context); // Close the web view
              },
            ),
          ),
        ),
      );

      // Wait for the result (either success or failure)
      return await completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () => false,
      );
    } catch (e) {
      // Handle any errors
      return false;
    }
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
