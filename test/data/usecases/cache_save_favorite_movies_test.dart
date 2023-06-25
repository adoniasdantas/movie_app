import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorageSave {}

class CacheSaveFavoriteMovies implements SaveFavoriteMovies {
  final CacheStorageSave cacheStorage;

  const CacheSaveFavoriteMovies({required this.cacheStorage});

  @override
  Future<void> call(List<int> movieIds) async {
    await cacheStorage.save(jsonEncode(movieIds));
  }
}

void main() {
  late CacheStorageSpy cacheStorageSpy;
  late CacheSaveFavoriteMovies sut;
  late List<int> movieIds;
  late String encodedData;

  When mockCacheStorageSave() => when(() => cacheStorageSpy.save(any()));

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = CacheSaveFavoriteMovies(cacheStorage: cacheStorageSpy);
    movieIds = faker.randomGenerator.numbers(100, 3);
    encodedData = jsonEncode(movieIds);
    mockCacheStorageSave().thenAnswer((_) async => _);
  });

  test('Should call cacheStorage with correct values', () async {
    await sut(movieIds);

    verify(() => cacheStorageSpy.save(encodedData)).called(1);
  });

  test('Should run successfully if no error is thrown', () async {
    final future = sut(movieIds);

    expect(future, isA<void>());
  });
}
