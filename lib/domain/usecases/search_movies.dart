import 'package:movie_app/domain/entities/entities.dart';

abstract class SearchMovies {
  Future<List<MovieEntity>> call(String url, String movieName);
}
