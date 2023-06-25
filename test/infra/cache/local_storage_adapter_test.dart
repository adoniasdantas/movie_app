import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:localstorage/localstorage.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageSpy localStorageSpy;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  void mockLocalStorageReadyCall() =>
      when(() => localStorageSpy.ready).thenAnswer((_) async => true);
  When mockLocalStorageGetItem() => when(() => localStorageSpy.getItem(key));
  When mockLocalStorageSetItem() =>
      when(() => localStorageSpy.setItem(key, value));

  setUp(() async {
    key = faker.lorem.sentence();
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
    value = "any_value";
    mockLocalStorageReadyCall();
    mockLocalStorageGetItem().thenAnswer((_) async => value);
    mockLocalStorageSetItem().thenAnswer((_) async => _);
  });

  group('Fetch', () {
    test('Should call Local Storage with correct value', () async {
      await sut.fetch(key);

      verify(() => localStorageSpy.getItem(key)).called(1);
    });

    test('Should return data correctly', () async {
      final data = await sut.fetch(key);

      expect(data, value);
    });

    test('Should throw UnexpectedError if LocalStorage throws', () async {
      mockLocalStorageGetItem().thenThrow(Exception());

      final future = sut.fetch(key);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Save', () {
    test('Should call Local Storage with correct value', () async {
      await sut.save(key, value);

      verify(() => localStorageSpy.setItem(key, value)).called(1);
    });

    test('Should save data correctly', () async {
      final future = sut.save(key, value);

      expect(future, isA<void>());
    });

    test('Should throw UnexpectedError if LocalStorage throws', () async {
      mockLocalStorageSetItem().thenThrow(Exception());

      final future = sut.save(key, value);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
