import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<AppException, AuthEntity>> generateSessionId(
      {required BuildContext context});
  Future<Either<AppException, String?>> getStoredSessionId();
  Future<Either<AppException, String?>> getStoredAccountId();
}
