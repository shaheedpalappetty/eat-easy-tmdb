part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvent {}

class GetCastDetailsEvent extends MovieDetailsEvent {
  final int movieId;

  GetCastDetailsEvent(this.movieId);
}

class AddToFavouritesEvent extends MovieDetailsEvent {
  final int movieId;

  AddToFavouritesEvent(this.movieId);
}

class AddToWatchListEvent extends MovieDetailsEvent {
  final int movieId;

  AddToWatchListEvent(this.movieId);
}
