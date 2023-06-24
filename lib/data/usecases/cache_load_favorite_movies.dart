import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

class CacheLoadFavoriteMovies implements LoadFavoriteMovies {
  final CacheStorage cacheStorage;

  const CacheLoadFavoriteMovies({required this.cacheStorage});

  @override
  Future<List<int>> call() async {
    try {
      final movieIds = await cacheStorage.fetch('favorite-movies');
      return movieIds;
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
