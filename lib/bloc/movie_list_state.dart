import 'package:equatable/equatable.dart';

import '../models/movie.dart';

class MovieListState extends Equatable {
  final bool isLoading;
  final List<Movie> movies;
  final List<int> favorites;
  final String error;
  final bool showFavoritesOnly;

  const MovieListState({
    this.isLoading = false,
    this.movies = const [],
    this.favorites = const [],
    this.error = '',
    this.showFavoritesOnly = false,
  });

  MovieListState copyWith({
    bool? isLoading,
    List<Movie>? movies,
    List<int>? favorites,
    String? error,
    bool? showFavoritesOnly,
  }) {
    return MovieListState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      favorites: favorites ?? this.favorites,
      error: error ?? this.error,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
    );
  }

  @override
  List<Object> get props =>
      [isLoading, movies, favorites, error, showFavoritesOnly];
}
