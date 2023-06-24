import 'dart:convert';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

class CacheLoadFavoriteMovies implements LoadFavoriteMovies {
  final CacheStorage cacheStorage;

  const CacheLoadFavoriteMovies({required this.cacheStorage});

  @override
  Future<List<int>> call() async {
    try {
      final json = await cacheStorage.fetch('favorite-movies');
      final movieIds = await jsonDecode(json) as List;
      return movieIds.map((id) => id as int).toList();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
