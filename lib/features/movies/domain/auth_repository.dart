import 'package:eat_easy_assignment/core/utils/imports.dart';

abstract class AuthRepository {
  Future<Either<AppException, AuthEntity>> generateSessionId(
      {required BuildContext context});
  Future<Either<AppException, String?>> getStoredSessionId();
  Future<Either<AppException, String?>> getStoredAccountId();
}
