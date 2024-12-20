import 'package:eat_easy_assignment/core/utils/imports.dart';

abstract class MoviesRepository {
  Future<Either<AppException, MovieListEntity>> getMovies(int page);
  Future<Either<AppException, MovieListEntity>> getFavoriteMovies(int page);
  Future<Either<AppException, MovieListEntity>> getWatchlistMovies(int page);
  Future<Either<AppException, MovieCastEntity>> getCastsDetails(int movieId);
  Future<Either<AppException, bool>> addToFavorites(int movieId);
  Future<Either<AppException, bool>> addToWatchlist(int movieId);
}
