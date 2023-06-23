import 'package:movie_app/data/http/http.dart';
import 'package:movie_app/data/models/models.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/load_movies.dart';

class LoadTrendingMovies implements LoadMovies {
  final String token;
  final HttpClient httpClient;

  const LoadTrendingMovies({
    required this.httpClient,
    required this.token,
  });

  @override
  Future<List<MovieEntity>> call(String url) async {
    try {
      final data = await httpClient.request(url: url, method: 'GET', headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      return (data['results'] as List)
          .map((movieJson) => MovieModel.fromJson(movieJson).toEntity())
          .toList();
    } on HttpError catch (httpError) {
      throw httpError == HttpError.unauthorized
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
