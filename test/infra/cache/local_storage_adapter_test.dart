import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:localstorage/localstorage.dart';
import 'package:movie_app/data/cache/cache.dart';
import 'package:movie_app/domain/errors/errors.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  const LocalStorageAdapter({required this.localStorage});

  @override
  Future<String> fetch(String key) async {
    try {
      return await localStorage.getItem(key);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}

void main() {
  late LocalStorageSpy localStorageSpy;
  late LocalStorageAdapter sut;
  late String key;
  late String resultData;

  When mockLocalStorageGetItem() => when(() => localStorageSpy.getItem(key));

  setUp(() async {
    key = faker.lorem.sentence();
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
    resultData = "[1, 2, 3]";
    mockLocalStorageGetItem().thenAnswer((_) => resultData);
  });

  test('Should call Local Storage with correct value', () async {
    await sut.fetch(key);

    verify(() => localStorageSpy.getItem(key)).called(1);
  });

  test('Should return data correctly', () async {
    final data = await sut.fetch(key);

    expect(data, resultData);
  });

  test('Should throw UnexpectedError if LocalStorage throws', () async {
    mockLocalStorageGetItem().thenThrow(Exception());

    final future = sut.fetch(key);

    expect(future, throwsA(DomainError.unexpected));
  });
}
