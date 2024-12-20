// movies_repository.dart
import 'package:eat_easy_assignment/core/exceptions/app_exception.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_cast_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:either_dart/either.dart';

abstract class MoviesRepository {
  Future<Either<AppException, MovieListEntity>> getMovies(int page);
  Future<Either<AppException, MovieListEntity>> getFavoriteMovies(int page);
  Future<Either<AppException, MovieListEntity>> getWatchlistMovies(int page);
  Future<Either<AppException, MovieCastEntity>> getCastsDetails(int movieId);
  Future<Either<AppException, bool>> addToFavorites(int movieId);
  Future<Either<AppException, bool>> addToWatchlist(int movieId);
}
