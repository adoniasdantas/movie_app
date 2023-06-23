import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int id;
  final String title;
  final String overview;
  final double averageGrade;
  final DateTime releaseDate;
  final String posterPath;
  final List<String>? genres;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.averageGrade,
    required this.releaseDate,
    required this.posterPath,
    this.genres,
  });

  MovieEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        overview = json['overview'],
        averageGrade = json['averageGrade'],
        releaseDate = json['releaseDate'],
        posterPath = json['posterPath'],
        genres =
            (json['genres'] as List?)?.map<String>((genre) => genre).toList();

  @override
  List<Object?> get props =>
      [id, title, overview, averageGrade, releaseDate, posterPath, genres];
}
