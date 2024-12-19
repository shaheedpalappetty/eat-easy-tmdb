import 'package:eat_easy_assignment/core/exceptions/app_exception.dart';
import 'package:either_dart/either.dart';

typedef EitherResponse<T> = Future<Either<AppException, T>>;
