import 'package:eat_easy_assignment/core/exceptions/app_exception.dart';
import 'package:eat_easy_assignment/core/network/http_client.dart';
import 'package:eat_easy_assignment/core/network/network_routes.dart';
import 'package:eat_easy_assignment/features/movies/data/data_model/movie_cast.dart';
import 'package:eat_easy_assignment/features/movies/data/data_model/movie_list.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_cast_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/movies_repository.dart';
import 'package:either_dart/either.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl();

  @override
  Future<Either<AppException, MovieListEntity>> getMovies(int page) async {
    final response = await ApiService.getApi(
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
    final response = await ApiService.getApi(
        '${NetworkRoutes.baserUrl}${NetworkRoutes.getCastDetails}$movieId/credits?language=en-US');

    return response.fold(
      (error) => Left(error),
      (casts) {
        final castsList = MovieCast.fromJson(casts);
        return Right(castsList.toEntity());
      },
    );
  }
}
