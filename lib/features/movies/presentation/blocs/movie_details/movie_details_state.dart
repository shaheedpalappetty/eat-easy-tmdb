part of 'movie_details_bloc.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieCastEntity cast;

  MovieDetailsLoaded(this.cast);
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError(this.message);
}

class AddToFavouritesSuccess extends MovieDetailsState {
  final int movieId;

  AddToFavouritesSuccess(this.movieId);
}

class AddToWatchListSuccess extends MovieDetailsState {
  final int movieId;

  AddToWatchListSuccess(this.movieId);
}
