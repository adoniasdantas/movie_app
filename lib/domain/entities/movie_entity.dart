import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int id;
  final String title;
  final String overview;
  final double averageGrade;
  final String posterPath;
  final DateTime? releaseDate;
  final List<String>? genres;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.averageGrade,
    required this.posterPath,
    this.releaseDate,
    this.genres,
  });

  @override
  List<Object?> get props =>
      [id, title, overview, averageGrade, releaseDate, posterPath, genres];
}
