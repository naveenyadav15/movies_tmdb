import 'package:equatable/equatable.dart';

import '../models/movie_detail.dart';

class MovieDetailState extends Equatable {
  final bool isLoading;
  final MovieDetail? movieDetail;
  final List<int> favorites;
  final String error;

  const MovieDetailState({
    this.isLoading = false,
    this.movieDetail,
    this.favorites = const [],
    this.error = '',
  });

  MovieDetailState copyWith({
    bool? isLoading,
    MovieDetail? movieDetail,
    List<int>? favorites,
    String? error,
  }) {
    return MovieDetailState(
      isLoading: isLoading ?? this.isLoading,
      movieDetail: movieDetail ?? this.movieDetail,
      favorites: favorites ?? this.favorites,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [isLoading, movieDetail ?? '', favorites, error];
}
