part of 'movie_details_bloc.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError(this.message);
}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieCastEntity cast;
  final bool isAddingToFavorites;
  final bool isAddingToWatchList;
  final String message;

  MovieDetailsLoaded({
    required this.cast,
    this.isAddingToFavorites = false,
    this.isAddingToWatchList = false,
    this.message = "",
  });

  MovieDetailsLoaded copyWith({
    MovieCastEntity? cast,
    bool? isAddingToFavorites,
    bool? isAddingToWatchList,
    String? message,
  }) {
    return MovieDetailsLoaded(
        cast: cast ?? this.cast,
        isAddingToFavorites: isAddingToFavorites ?? this.isAddingToFavorites,
        isAddingToWatchList: isAddingToWatchList ?? this.isAddingToWatchList,
        message: message ?? this.message);
  }
}
