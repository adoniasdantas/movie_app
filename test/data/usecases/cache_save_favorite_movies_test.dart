import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorageSave {}

void main() {
  late CacheStorageSpy cacheStorageSpy;
  late CacheSaveFavoriteMovies sut;
  late List<int> movieIds;
  late String encodedData;
  late String key;

  When mockCacheStorageSave() => when(() => cacheStorageSpy.save(any(), any()));

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = CacheSaveFavoriteMovies(cacheStorage: cacheStorageSpy);
    movieIds = [1, 2, 3];
    encodedData = jsonEncode(movieIds);
    key = 'favorite-movies';
    mockCacheStorageSave().thenAnswer((_) async => _);
  });

  test('Should call cacheStorage with correct values', () async {
    await sut(movieIds);

    verify(() => cacheStorageSpy.save(key, encodedData)).called(1);
  });

  test('Should not pass duplicated ids', () async {
    const ids = [1, 1, 1, 2];
    await sut(ids);

    verify(() => cacheStorageSpy.save(key, jsonEncode([1, 2]))).called(1);
  });

  test('Should run successfully if no error is thrown', () async {
    final future = sut(movieIds);

    expect(future, isA<void>());
  });

  test('Should throws UnexpectedError if cacheStorage throws', () async {
    mockCacheStorageSave().thenThrow(Exception());

    final future = sut(movieIds);

    expect(future, throwsA(DomainError.unexpected));
  });
}
