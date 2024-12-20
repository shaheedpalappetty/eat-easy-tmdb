part of 'movies_bloc.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final MovieListEntity movies;
  final MovieListEntity? favoriteMovies;
  final MovieListEntity? watchlistMovies;
  final int currentPage;
  final int totalPages;
  final bool isLoading;

  MoviesLoaded({
    required this.movies,
    this.favoriteMovies,
    this.watchlistMovies,
    required this.currentPage,
    required this.totalPages,
    this.isLoading = false,
  });
  MoviesLoaded copyWith({
    required MovieListEntity movies,
    MovieListEntity? favoriteMovies,
    MovieListEntity? watchlistMovies,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
  }) {
    return MoviesLoaded(
      movies: movies,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MoviesError extends MoviesState {
  final String message;

  MoviesError(this.message);
}
