part of 'movies_bloc.dart';

abstract class MoviesEvent {}

class FetchMovies extends MoviesEvent {}

class LoadSpecificPage extends MoviesEvent {
  final int page;
  LoadSpecificPage(this.page);
}