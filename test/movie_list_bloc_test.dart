import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_tmdb/bloc/movie_list_bloc.dart';
import 'package:movies_tmdb/bloc/movie_list_event.dart';
import 'package:movies_tmdb/bloc/movie_list_state.dart';
import 'package:movies_tmdb/models/movie.dart';
import 'package:movies_tmdb/repositories/favorite_repository.dart';
import 'package:movies_tmdb/repositories/movie_repository.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {
  @override
  Future<List<int>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(int movieId) {
    // TODO: implement removeFavorite
    throw UnimplementedError();
  }
}

void main() {
  late MovieListBloc movieListBloc;
  late MockMovieRepository movieRepository;
  late MockFavoriteRepository favoriteRepository;

  setUp(() {
    movieRepository = MockMovieRepository();
    favoriteRepository = MockFavoriteRepository();
    movieListBloc = MovieListBloc(movieRepository as MovieRepository,
        favoriteRepository as FavoriteRepository);
  });

  tearDown(() {
    movieListBloc.close();
  });

  blocTest<MovieListBloc, MovieListState>(
    'emits [loading, success] when FetchMovies succeeds',
    build: () {
      when(() => movieRepository.fetchMovies('')).thenAnswer((_) async =>
          [const Movie(id: 1, title: 'Test Movie', posterPath: '', genre: '')]);
      when(() => favoriteRepository.getFavorites()).thenAnswer((_) async => []);
      return movieListBloc;
    },
    act: (bloc) => bloc.add(const FetchMovies('')),
    expect: () => [
      const MovieListState(isLoading: true, error: ''),
      const MovieListState(
        isLoading: false,
        movies: [Movie(id: 1, title: 'Test Movie', posterPath: '', genre: '')],
        favorites: [],
      ),
    ],
  );
}
