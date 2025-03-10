import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/movie.dart';
import '../models/movie_detail.dart';

class TMDBService {
  final String apiKey = dotenv.get('TMDB_API_KEY');
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchMovies(String query) async {
    final url = query.isEmpty
        ? '$baseUrl/movie/popular?api_key=$apiKey'
        : '$baseUrl/search/movie?api_key=$apiKey&query=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return MovieDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
