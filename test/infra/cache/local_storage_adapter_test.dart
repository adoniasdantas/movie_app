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
    await localStorage.getItem(key);
  }
}

void main() {
  test('Should call Local Storage with correct value', () async {
    final key = faker.lorem.sentence();
    final localStorageSpy = LocalStorageSpy();
    final sut = LocalStorageAdapter(localStorage: localStorageSpy);
    when(() => localStorageSpy.getItem(key)).thenAnswer((_) => _);

    await sut.fetch(key);

    verify(() => localStorageSpy.getItem(key)).called(1);
  });
}
