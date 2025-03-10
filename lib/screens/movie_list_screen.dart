import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_tmdb/screens/movie_detail_screen.dart';

import '../bloc/movie_list_bloc.dart';
import '../bloc/movie_list_event.dart';
import '../bloc/movie_list_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          BlocBuilder<MovieListBloc, MovieListState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.showFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  context.read<MovieListBloc>().add(ToggleViewMode());
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search movies...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<MovieListBloc>().add(FetchMovies(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error.isNotEmpty) {
                  return CustomErrorWidget(
                    message: state.error,
                    onRetry: () {
                      context
                          .read<MovieListBloc>()
                          .add(FetchMovies(_searchController.text));
                    },
                  );
                }
                if (state.movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }

                final displayedMovies = state.showFavoritesOnly
                    ? state.movies
                        .where((movie) => state.favorites.contains(movie.id))
                        .toList()
                    : state.movies;

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: displayedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = displayedMovies[index];
                    return MovieCard(
                      movie: movie,
                      isFavorite: state.favorites.contains(movie.id),
                      onFavoriteToggle: () {
                        context
                            .read<MovieListBloc>()
                            .add(ToggleFavorite(movie));
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movieId: movie.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
