import 'package:faker/faker.dart';
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
    final movieIds = await cacheStorage.fetch('favorite-movies');
    return movieIds;
  }
}

void main() {
  late CacheStorageSpy cacheStorageSpy;
  late CacheLoadFavoriteMovies sut;
  late List<int> data;

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = CacheLoadFavoriteMovies(cacheStorage: cacheStorageSpy);
    data = faker.randomGenerator.numbers(100, 3);
  });

  test('Should call cacheStorage with correct values', () async {
    when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => _);
    await sut();

    verify(() => cacheStorageSpy.fetch('favorite-movies')).called(1);
  });

  test('Should return a list of integers on success', () async {
    when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => data);
    final movieIds = await sut();

    expect(movieIds, data);
  });
}
