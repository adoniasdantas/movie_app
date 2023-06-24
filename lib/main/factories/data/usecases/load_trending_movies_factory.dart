import 'package:movie_app/api.dart';
import 'package:movie_app/data/usecases/usecases.dart';
import 'package:movie_app/main/factories/infra/http/http_adapter_factory.dart';

LoadTrendingMovies makeLoadTrendingMovies() {
  return LoadTrendingMovies(httpClient: makeHttpAdapter(), token: bearerToken);
}
