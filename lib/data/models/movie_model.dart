import 'package:movie_app/api.dart';
import 'package:movie_app/data/http/http.dart';
import 'package:movie_app/domain/entities/movie_entity.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final num averageGrade;
  final String posterPath;
  final DateTime? releaseDate;
  final List<String>? genres;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.averageGrade,
    required this.posterPath,
    this.releaseDate,
    this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    try {
      return MovieModel(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        averageGrade: (json['vote_average'] as num).toDouble(),
        posterPath: '$initialUrlJunk${json['poster_path']}',
        releaseDate: DateTime.tryParse(json['release_date']),
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
        averageGrade: averageGrade.toDouble(),
        releaseDate: releaseDate,
        posterPath: posterPath,
      );
}
