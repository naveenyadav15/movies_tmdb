import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/favorite_repository.dart';
import '../repositories/movie_repository.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepository movieRepository;
  final FavoriteRepository favoriteRepository;

  MovieDetailBloc(this.movieRepository, this.favoriteRepository)
      : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<ToggleDetailFavorite>(_onToggleDetailFavorite);
  }

  Future<void> _onFetchMovieDetail(
      FetchMovieDetail event, Emitter<MovieDetailState> emit) async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final movieDetail = await movieRepository.fetchMovieDetail(event.movieId);
      final favorites = await favoriteRepository.getFavorites();
      emit(state.copyWith(
        isLoading: false,
        movieDetail: movieDetail,
        favorites: favorites,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggleDetailFavorite(
      ToggleDetailFavorite event, Emitter<MovieDetailState> emit) async {
    final favorites = List<int>.from(state.favorites);
    if (favorites.contains(event.movieId)) {
      await favoriteRepository.removeFavorite(event.movieId);
      favorites.remove(event.movieId);
    } else {
      final movieDetail = state.movieDetail;
      await favoriteRepository.addFavorite(event.movieId, {
        'title': movieDetail?.title ?? 'Unknown Title',
        'posterPath': movieDetail?.posterPath ?? '',
      });
      favorites.add(event.movieId);
    }
    emit(state.copyWith(favorites: favorites));
  }
}
