import 'dart:convert';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

class CacheSaveFavoriteMovies implements SaveFavoriteMovies {
  final CacheStorageSave cacheStorage;

  const CacheSaveFavoriteMovies({required this.cacheStorage});

  @override
  Future<void> call(List<int> movieIds) async {
    try {
      final uniqueIds = movieIds.toSet().toList();
      await cacheStorage.save('favorite-movies', jsonEncode(uniqueIds));
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
