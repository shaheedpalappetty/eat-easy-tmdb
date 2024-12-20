import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eat_easy_assignment/core/logger/logger.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/movies_repository.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository _moviesRepository;

  MoviesBloc(this._moviesRepository) : super(MoviesInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<LoadSpecificPage>(_onLoadSpecificPage);
  }

  Future<void> _onLoadSpecificPage(
    LoadSpecificPage event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      // Preserve the current state while showing loading
      emit(MoviesLoaded(
        movies: currentState.movies,
        favoriteMovies: currentState.favoriteMovies, // Preserve favorites
        watchlistMovies: currentState.watchlistMovies, // Preserve watchlist
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        isLoading: true,
      ));

      final result = await _moviesRepository.getMovies(event.page);

      result.fold(
        (failure) => emit(MoviesError(failure.message)),
        (movies) => emit(MoviesLoaded(
          movies: movies,
          favoriteMovies: currentState.favoriteMovies, // Keep favorites
          watchlistMovies: currentState.watchlistMovies, // Keep watchlist
          currentPage: event.page,
          totalPages: movies.page ?? event.page,
          isLoading: false,
        )),
      );
    }
  }

  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MoviesState> emit) async {
    emit(MoviesLoading());
    const int currentPage = 1;

    try {
      final results = await Future.wait([
        _moviesRepository.getMovies(currentPage),
        _moviesRepository.getWatchlistMovies(currentPage),
        _moviesRepository.getFavoriteMovies(currentPage),
      ]);

      final moviesResult = results[0];
      final watchlistResult = results[1];
      final favoritesResult = results[2];

      moviesResult.fold(
        (failure) => emit(MoviesError(failure.message)),
        (movies) {
          MovieListEntity? watchlist;
          MovieListEntity? favorites;

          watchlistResult.fold(
            (failure) => Logger.log('Watchlist error: ${failure.message}'),
            (watchlistMovies) => watchlist = watchlistMovies,
          );

          favoritesResult.fold(
            (failure) => Logger.log('Favorites error: ${failure.message}'),
            (favoriteMovies) => favorites = favoriteMovies,
          );

          emit(MoviesLoaded(
            movies: movies,
            watchlistMovies: watchlist,
            favoriteMovies: favorites,
            totalPages: movies.page ?? 0,
            currentPage: movies.page != null ? 1 : 0,
          ).copyWith(movies: movies));
        },
      );
    } catch (e) {
      emit(MoviesError('Failed to fetch movies: ${e.toString()}'));
    }
  }
}
