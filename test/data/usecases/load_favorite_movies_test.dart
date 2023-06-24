import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/domain/usecases/usecases.dart';

abstract class CacheStorage {
  Future<dynamic> fetch(String key);
}

class CacheStorageSpy extends Mock implements CacheStorage {}

class CacheLoadFavoriteMovies implements LoadFavoriteMovies {
  final CacheStorage cacheStorage;

  const CacheLoadFavoriteMovies({required this.cacheStorage});

  @override
  Future<List<int>> call() async {
    await cacheStorage.fetch('favorite-movies');
    return Future.value([]);
  }
}

void main() {
  late CacheStorageSpy cacheStorageSpy;
  late CacheLoadFavoriteMovies sut;

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = CacheLoadFavoriteMovies(cacheStorage: cacheStorageSpy);
  });

  test('Should call cacheStorage with correct values', () async {
    when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => _);
    await sut();

    verify(() => cacheStorageSpy.fetch('favorite-movies')).called(1);
  });
}
