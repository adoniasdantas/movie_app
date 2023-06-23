class MovieEntity {
  final String title;
  final String overview;
  final double averageGrade;
  final DateTime releaseDate;
  final String posterPath;
  final List<String> genres;

  const MovieEntity({
    required this.title,
    required this.overview,
    required this.averageGrade,
    required this.releaseDate,
    required this.posterPath,
    required this.genres,
  });
}
