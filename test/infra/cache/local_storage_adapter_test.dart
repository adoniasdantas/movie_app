import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:localstorage/localstorage.dart';
import 'package:movie_app/data/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  const LocalStorageAdapter({required this.localStorage});

  @override
  Future<dynamic> fetch(String key) async {
    return await localStorage.getItem(key);
  }
}

void main() {
  late LocalStorageSpy localStorageSpy;
  late LocalStorageAdapter sut;
  late String key;
  late String resultData;

  setUp(() async {
    key = faker.lorem.sentence();
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
    resultData = faker.lorem.sentence();
    when(() => localStorageSpy.getItem(key)).thenAnswer((_) => resultData);
  });

  test('Should call Local Storage with correct value', () async {
    await sut.fetch(key);

    verify(() => localStorageSpy.getItem(key)).called(1);
  });

  test('Should return data correctly', () async {
    final data = await sut.fetch(key);

    expect(data, resultData);
  });
}
