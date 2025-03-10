import 'package:equatable/equatable.dart';

class MovieDetail extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? releaseDate;

  const MovieDetail({
    required this.id,
    this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] as String?,
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, title, posterPath, overview, releaseDate];
}
