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
        (cast) => emit(MovieDetailsLoaded(cast)),
      );
    } catch (e) {
      emit(MovieDetailsError("An unexpected error occurred"));
    }
  }

  void _onAddToFavourites(
      AddToFavouritesEvent event, Emitter<MovieDetailsState> emit) {
    // Add logic to handle adding to favourites
    emit(AddToFavouritesSuccess(event.movieId));
  }

  void _onAddToWatchList(
      AddToWatchListEvent event, Emitter<MovieDetailsState> emit) {
    // Add logic to handle adding to the watchlist
    emit(AddToWatchListSuccess(event.movieId));
  }
}
