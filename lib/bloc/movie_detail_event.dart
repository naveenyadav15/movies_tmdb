import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

class FetchMovieDetail extends MovieDetailEvent {
  final int movieId;

  const FetchMovieDetail(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class ToggleDetailFavorite extends MovieDetailEvent {
  final int movieId;

  const ToggleDetailFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
}
