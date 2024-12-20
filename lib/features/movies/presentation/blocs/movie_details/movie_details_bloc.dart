import 'package:bloc/bloc.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_cast_entity.dart';
import 'package:eat_easy_assignment/features/movies/domain/movies_repository.dart';
part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MoviesRepository repository;

  MovieDetailsBloc({required this.repository}) : super(MovieDetailsInitial()) {
    on<GetCastDetailsEvent>(_onGetCastDetails);
    on<AddToFavouritesEvent>(_onAddToFavourites);
    on<AddToWatchListEvent>(_onAddToWatchList);
  }

  Future<void> _onGetCastDetails(
      GetCastDetailsEvent event, Emitter<MovieDetailsState> emit) async {
    emit(MovieDetailsLoading());
    try {
      final result = await repository.getCastsDetails(event.movieId);
      result.fold(
        (error) => emit(MovieDetailsError(error.message)),
        (cast) => emit(MovieDetailsLoaded(cast: cast)),
      );
    } catch (e) {
      emit(MovieDetailsError("An unexpected error occurred"));
    }
  }

  Future<void> _onAddToFavourites(
      AddToFavouritesEvent event, Emitter<MovieDetailsState> emit) async {
    if (state is MovieDetailsLoaded) {
      emit((state as MovieDetailsLoaded).copyWith(isAddingToFavorites: true));
    }
    try {
      final result = await repository.addToFavorites(event.movieId);
      result.fold(
        (error) => emit(MovieDetailsError("Failed to Add Favourites")),
        (_) => emit((state as MovieDetailsLoaded).copyWith(
          isAddingToFavorites: false,
        )),
      );
    } catch (e) {
      emit(MovieDetailsError("An unexpected error occurred"));
    }
  }

  Future<void> _onAddToWatchList(
      AddToWatchListEvent event, Emitter<MovieDetailsState> emit) async {
    if (state is MovieDetailsLoaded) {
      emit((state as MovieDetailsLoaded)
          .copyWith(isAddingToWatchList: true, message: "Added to Favourites"));
    }

    try {
      final result = await repository.addToWatchlist(event.movieId);
      result.fold(
        (error) => emit(MovieDetailsError("Failed to Add WatchList")),
        (_) => emit((state as MovieDetailsLoaded).copyWith(
            isAddingToWatchList: false, message: "Added to WatchLists")),
      );
    } catch (e) {
      emit(MovieDetailsError("An unexpected error occurred"));
    }
  }
}
