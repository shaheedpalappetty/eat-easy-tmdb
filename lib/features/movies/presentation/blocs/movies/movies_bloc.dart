import 'dart:async';

import 'package:bloc/bloc.dart';
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
      emit(MoviesLoaded(
        movies: currentState.movies,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        isLoading: true,
      ));
    }

    final result = await _moviesRepository.getMovies(event.page);

    result.fold(
      (failure) => emit(MoviesError(failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        currentPage: event.page,
        totalPages: movies.page ??
            event.page, // Replace with actual total pages from API
        isLoading: false,
      )),
    );
  }

  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MoviesState> emit) async {
    emit(MoviesLoading());
    const int currentPage = 1;

    final result = await _moviesRepository.getMovies(currentPage);

    result.fold(
      (failure) => emit(MoviesError(failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        totalPages: movies.page ?? 0,
        currentPage: movies.page != null ? 1 : 0,
      )),
    );
  }
}
