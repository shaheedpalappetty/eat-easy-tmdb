import 'package:eat_easy_assignment/core/exceptions/app_exception.dart';
import 'package:eat_easy_assignment/core/network/http_client.dart';
import 'package:eat_easy_assignment/core/network/network_routes.dart';
import 'package:eat_easy_assignment/features/movies/data/data_model/movie_cast.dart';
import 'package:eat_easy_assignment/features/movies/data/data_model/movie_list.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_local_datasource.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_cast_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/movies_repository.dart';
import 'package:either_dart/either.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl(this.authLocalDataSource);
  final AuthLocalDataSource authLocalDataSource;
  @override
  Future<Either<AppException, MovieListEntity>> getMovies(int page) async {
    final response = await ApiService.get(
        '${NetworkRoutes.baserUrl}${NetworkRoutes.fetchMovies}?include_adult=true&page=$page');

    return response.fold(
      (error) => Left(error),
      (data) {
        final movieList = MovieList.fromJson(data);
        return Right(movieList.toEntity());
      },
    );
  }

  @override
  Future<Either<AppException, MovieCastEntity>> getCastsDetails(
      int movieId) async {
    final response = await ApiService.get(
        '${NetworkRoutes.baserUrl}${NetworkRoutes.getCastDetails}$movieId/credits?language=en-US');

    return response.fold(
      (error) => Left(error),
      (casts) {
        final castsList = MovieCast.fromJson(casts);
        return Right(castsList.toEntity());
      },
    );
  }

  @override
  Future<Either<AppException, MovieListEntity>> getFavoriteMovies(
      int page) async {
    try {
      final accountId = await authLocalDataSource.getAccountId();
      final response = await ApiService.get(
        '${NetworkRoutes.baserUrl}/account/$accountId/favorite/movies',
        queryParameters: {
          'language': 'en-US',
          'page': page.toString(),
          'sort_by': 'created_at.asc'
        },
      );

      return response.fold(
        (error) => Left(error),
        (data) {
          final movieList = MovieList.fromJson(data);
          return Right(movieList.toEntity());
        },
      );
    } catch (e) {
      return Left(AppException('Failed to fetch favorite movies'));
    }
  }

  @override
  Future<Either<AppException, MovieListEntity>> getWatchlistMovies(
      int page) async {
    try {
      final accountId = await authLocalDataSource.getAccountId();
      final response = await ApiService.get(
        '${NetworkRoutes.baserUrl}/account/$accountId/watchlist/movies',
        queryParameters: {
          'language': 'en-US',
          'page': page.toString(),
          'sort_by': 'created_at.asc'
        },
      );

      return response.fold(
        (error) => Left(error),
        (data) {
          final movieList = MovieList.fromJson(data);
          return Right(movieList.toEntity());
        },
      );
    } catch (e) {
      return Left(AppException('Failed to fetch watchlist movies'));
    }
  }

  @override
  Future<Either<AppException, bool>> addToFavorites(int movieId) async {
    try {
      final accountId = await authLocalDataSource.getAccountId();
      final sessionId = await authLocalDataSource.getSessionId();
      final response = await ApiService.post(
        '${NetworkRoutes.baserUrl}/account/$accountId/favorite',
        {'media_type': 'movie', 'media_id': movieId, 'favorite': true},
        queryParameters: {
          'session_id':
              sessionId, // You'll need to implement session management
        },
      );

      return response.fold(
        (error) => Left(error),
        (data) => const Right(true),
      );
    } catch (e) {
      return Left(AppException('Failed to add to favorites'));
    }
  }

  @override
  Future<Either<AppException, bool>> addToWatchlist(int movieId) async {
    try {
      final accountId = await authLocalDataSource.getAccountId();
      final sessionId = await authLocalDataSource.getSessionId();
      final response = await ApiService.post(
        '${NetworkRoutes.baserUrl}/account/$accountId/watchlist',
        {'media_type': 'movie', 'media_id': movieId, 'watchlist': true},
        queryParameters: {
          'session_id':
              sessionId, // You'll need to implement session management
        },
      );

      return response.fold(
        (error) => Left(error),
        (data) => const Right(true),
      );
    } catch (e) {
      return Left(AppException('Failed to add to watchlist'));
    }
  }
}
