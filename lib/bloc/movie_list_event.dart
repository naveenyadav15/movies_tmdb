import 'package:equatable/equatable.dart';
import 'package:movies_tmdb/models/movie.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();
}

class FetchMovies extends MovieListEvent {
  final String query;

  const FetchMovies(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleFavorite extends MovieListEvent {
  final Movie movie;

  const ToggleFavorite(this.movie);

  @override
  List<Object> get props => [movie];
}

class ToggleViewMode extends MovieListEvent {
  @override
  List<Object> get props => [];
}
