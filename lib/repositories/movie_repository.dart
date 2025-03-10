import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/connectivity_service.dart';
import '../services/tmdb_service.dart';

class MovieRepository {
  final TMDBService tmdbService;
  final ConnectivityService connectivityService;

  MovieRepository(this.tmdbService, this.connectivityService);

  Future<List<Movie>> fetchMovies(String query) async {
    if (await connectivityService.isConnected()) {
      return await tmdbService.fetchMovies(query);
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    if (await connectivityService.isConnected()) {
      return await tmdbService.fetchMovieDetail(movieId);
    } else {
      throw Exception('No internet connection');
    }
  }
}
