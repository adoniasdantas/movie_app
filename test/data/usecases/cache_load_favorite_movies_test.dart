import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  late CacheStorageSpy cacheStorageSpy;
  late CacheLoadFavoriteMovies sut;
  late String data;
  late List<int> resultData;

  When mockCacheStorageFetch() => when(() => cacheStorageSpy.fetch(any()));

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = CacheLoadFavoriteMovies(cacheStorage: cacheStorageSpy);
    resultData = faker.randomGenerator.numbers(100, 3);
    data = jsonEncode(resultData);
    mockCacheStorageFetch().thenAnswer((_) async => data);
  });

  test('Should call cacheStorage with correct values', () async {
    await sut();

    verify(() => cacheStorageSpy.fetch('favorite-movies')).called(1);
  });

  test('Should return a list of integers on success', () async {
    final movieIds = await sut();

    expect(movieIds, resultData);
  });

  test('Should throws UnexpectedError if cacheStorage throws', () async {
    mockCacheStorageFetch().thenThrow(Exception());

    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cacheStorage returns invalid data',
      () async {
    mockCacheStorageFetch().thenAnswer((_) async => ["1", null]);

    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });
}
