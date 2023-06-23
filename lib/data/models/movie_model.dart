import 'package:movie_app/data/http/http.dart';
import 'package:movie_app/domain/entities/movie_entity.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final double averageGrade;
  final DateTime releaseDate;
  final String posterPath;
  final List<String>? genres;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.averageGrade,
    required this.releaseDate,
    required this.posterPath,
    this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    try {
      return MovieModel(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        averageGrade: json['averageGrade'],
        releaseDate: DateTime.parse(json['releaseDate']),
        posterPath: json['posterPath'],
        genres:
            (json['genres'] as List?)?.map<String>((genre) => genre).toList(),
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  MovieEntity toEntity() => MovieEntity(
        id: id,
        title: title,
        overview: overview,
        averageGrade: averageGrade,
        releaseDate: releaseDate,
        posterPath: posterPath,
      );
}
