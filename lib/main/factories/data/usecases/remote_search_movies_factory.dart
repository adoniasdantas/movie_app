import 'package:movie_app/api.dart';
import 'package:movie_app/data/usecases/usecases.dart';
import 'package:movie_app/main/factories/infra/http/http_adapter_factory.dart';

RemoteSearchMovies makeRemoteSearchMovies() {
  return RemoteSearchMovies(httpClient: makeHttpAdapter(), token: bearerToken);
}
