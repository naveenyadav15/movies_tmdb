import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_tmdb/models/movie.dart';

import '../repositories/favorite_repository.dart';
import '../repositories/movie_repository.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository movieRepository;
  final FavoriteRepository favoriteRepository;

  MovieListBloc(this.movieRepository, this.favoriteRepository)
      : super(const MovieListState()) {
    on<FetchMovies>(_onFetchMovies);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ToggleViewMode>(_onToggleViewMode);

    // Initial load
    add(const FetchMovies(''));
  }
  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      if (await movieRepository.connectivityService.isConnected()) {
        final movies = await movieRepository.fetchMovies(event.query);
        final favorites = await favoriteRepository.getFavorites();
        emit(state.copyWith(
          isLoading: false,
          movies: movies,
          favorites: favorites,
        ));
      } else {
        final favoriteMovies = await favoriteRepository.getFavoriteMovies();
        final movies = favoriteMovies.map((json) {
          return Movie(
            id: json['id'],
            title: json['title'] as String?,
            posterPath: json['posterPath'] as String?,
            genre: json['genre'] as String? ?? '--',
          );
        }).toList();
        final favorites = await favoriteRepository.getFavorites();
        emit(state.copyWith(
          isLoading: false,
          movies: movies,
          favorites: favorites,
          showFavoritesOnly: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<MovieListState> emit) async {
    final favorites = List<int>.from(state.favorites);
    if (favorites.contains(event.movie.id)) {
      await favoriteRepository.removeFavorite(event.movie.id);
      favorites.remove(event.movie.id);
    } else {
      await favoriteRepository.addFavorite(event.movie.id, {
        'title': event.movie.title,
        'posterPath': event.movie.posterPath,
      });
      favorites.add(event.movie.id);
    }
    emit(state.copyWith(favorites: favorites));
  }

  Future<void> _onToggleViewMode(
      ToggleViewMode event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(showFavoritesOnly: !state.showFavoritesOnly));
  }
}
