import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepository {
  static const String _favoritesKey = 'favorites';
  static const String _favoriteMoviesKey = 'favorite_movies';

  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((id) => int.parse(id)).toList();
  }

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMoviesJson = prefs.getStringList(_favoriteMoviesKey) ?? [];
    return favoriteMoviesJson
        .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
        .toList();
  }

  Future<void> addFavorite(int movieId, Map<String, dynamic> movieData) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(movieId)) {
      favorites.add(movieId);
      await prefs.setStringList(
          _favoritesKey, favorites.map((id) => id.toString()).toList());
    }
    final favoriteMovies = await getFavoriteMovies();
    favoriteMovies.add({'id': movieId, ...movieData});
    await prefs.setStringList(_favoriteMoviesKey,
        favoriteMovies.map((movie) => jsonEncode(movie)).toList());
  }

  Future<void> removeFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(movieId);
    await prefs.setStringList(
        _favoritesKey, favorites.map((id) => id.toString()).toList());
    final favoriteMovies = await getFavoriteMovies();
    favoriteMovies.removeWhere((movie) => movie['id'] == movieId);
    await prefs.setStringList(_favoriteMoviesKey,
        favoriteMovies.map((movie) => jsonEncode(movie)).toList());
  }
}
