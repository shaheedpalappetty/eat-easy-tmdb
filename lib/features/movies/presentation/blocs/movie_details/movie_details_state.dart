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





// //States for AddToFavourite
// class AddToFavouritesLoading extends MovieDetailsState {}

// class AddToFavouritesErrror extends MovieDetailsState {
//   final String message;

//   AddToFavouritesErrror(this.message);
// }

// class AddToFavouritesSuccess extends MovieDetailsState {
//   final int movieId;

//   AddToFavouritesSuccess(this.movieId);
// }

// //States for AddToWatchList
// class AddToWatchListLoading extends MovieDetailsState {}

// class AddToWatchListErrror extends MovieDetailsState {
//   final String message;

//   AddToWatchListErrror(this.message);
// }

// class AddToWatchListSuccess extends MovieDetailsState {
//   final int movieId;

//   AddToWatchListSuccess(this.movieId);
// }

// class MovieDetailsLoaded extends MovieDetailsState {
//   final MovieCastEntity cast;

//   MovieDetailsLoaded(this.cast);
// }
