// movies_repository.dart
import 'package:eat_easy_assignment/core/exceptions/app_exception.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:either_dart/either.dart';

abstract class MoviesRepository {
  Future<Either<AppException, MovieListEntity>> getMovies(int page);
}
