import 'package:movie_app/data/usecases/usecases.dart';
import 'package:movie_app/main/factories/infra/cache/local_storage_adapter_factory.dart';

CacheLoadFavoriteMovies makeCacheLoadFavoriteMovies() {
  return CacheLoadFavoriteMovies(cacheStorage: makeLocalStorageAdapter());
}
