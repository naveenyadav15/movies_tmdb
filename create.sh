
#!/bin/bash

# Create the base lib directory (if it doesn't already exist)
mkdir -p lib

# Create subdirectories
mkdir -p lib/bloc
mkdir -p lib/models
mkdir -p lib/repositories
mkdir -p lib/screens
mkdir -p lib/widgets
mkdir -p lib/services

# Create files in the bloc folder
touch lib/bloc/movie_list_bloc.dart
touch lib/bloc/movie_list_event.dart
touch lib/bloc/movie_list_state.dart
touch lib/bloc/movie_detail_bloc.dart
touch lib/bloc/movie_detail_event.dart
touch lib/bloc/movie_detail_state.dart

# Create files in the models folder
touch lib/models/movie.dart
touch lib/models/movie_detail.dart

# Create files in the repositories folder
touch lib/repositories/movie_repository.dart
touch lib/repositories/favorite_repository.dart

# Create files in the screens folder
touch lib/screens/movie_list_screen.dart
touch lib/screens/movie_detail_screen.dart

# Create files in the widgets folder
touch lib/widgets/movie_card.dart
touch lib/widgets/error_widget.dart

# Create files in the services folder
touch lib/services/tmdb_service.dart
touch lib/services/connectivity_service.dart

# Create the main entry point file
touch lib/main.dart

echo "Project structure created successfully."
