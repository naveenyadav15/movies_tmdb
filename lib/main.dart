import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/movie_detail_bloc.dart';
import 'bloc/movie_list_bloc.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/movie_repository.dart';
import 'screens/movie_list_screen.dart';
import 'services/connectivity_service.dart';
import 'services/tmdb_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tmdbService = TMDBService();
    final connectivityService = ConnectivityService();
    final movieRepository = MovieRepository(tmdbService, connectivityService);
    final favoriteRepository = FavoriteRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MovieListBloc(movieRepository, favoriteRepository),
        ),
        BlocProvider(
          create: (context) =>
              MovieDetailBloc(movieRepository, favoriteRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MovieListScreen(),
      ),
    );
  }
}
