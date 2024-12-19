part of 'movies_bloc.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final MovieListEntity movies;
  final int currentPage;
  final int totalPages;
  final bool isLoading;

  MoviesLoaded({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    this.isLoading = false,
  });
}

class MoviesError extends MoviesState {
  final String message;

  MoviesError(this.message);
}
