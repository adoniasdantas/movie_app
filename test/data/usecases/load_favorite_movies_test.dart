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
  late List<int> data;

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = CacheLoadFavoriteMovies(cacheStorage: cacheStorageSpy);
    data = faker.randomGenerator.numbers(100, 3);
  });

  test('Should call cacheStorage with correct values', () async {
    when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => data);
    await sut();

    verify(() => cacheStorageSpy.fetch('favorite-movies')).called(1);
  });

  test('Should return a list of integers on success', () async {
    when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => data);
    final movieIds = await sut();

    expect(movieIds, data);
  });

  test('Should throws UnexpectedError if cacheStorage throws', () async {
    when(() => cacheStorageSpy.fetch(any())).thenThrow(Exception());
    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cacheStorage returns invalid data',
      () async {
    when(() => cacheStorageSpy.fetch(any()))
        .thenAnswer((_) async => ["1", null]);
    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });
}
