import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? genre;

  const Movie({
    required this.id,
    this.title,
    this.posterPath,
    this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] as String?,
      posterPath: json['poster_path'] as String?,
      genre: (json['genre_ids'] as List<dynamic>?)?.join(', ') ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title, posterPath, genre];
}
