import 'package:movie_app/domain/entities/movie_entity.dart';

abstract class LoadMovies {
  Future<List<MovieEntity>> call(String url);
}
