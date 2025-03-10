import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_detail_bloc.dart';
import '../bloc/movie_detail_event.dart';
import '../bloc/movie_detail_state.dart';
import '../widgets/error_widget.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    context.read<MovieDetailBloc>().add(FetchMovieDetail(movieId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            if (state.error.contains('No internet connection')) {
              return const Center(
                  child: Text(
                      'No internet connection. Please check your connection.'));
            }
            return CustomErrorWidget(
              message: state.error,
              onRetry: () {
                context.read<MovieDetailBloc>().add(FetchMovieDetail(movieId));
              },
            );
          }
          if (state.movieDetail == null) {
            return const Center(child: Text('No details available'));
          }

          final movie = state.movieDetail!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title ?? "Title",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              state.favorites.contains(movie.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: state.favorites.contains(movie.id)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              context
                                  .read<MovieDetailBloc>()
                                  .add(ToggleDetailFavorite(movie.id));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Release Date: ${movie.releaseDate}'),
                      const SizedBox(height: 16),
                      const Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(movie.overview ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
