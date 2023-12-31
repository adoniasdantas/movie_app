import 'package:localstorage/localstorage.dart';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';

class LocalStorageAdapter implements CacheStorageFetch, CacheStorageSave {
  final LocalStorage localStorage;

  const LocalStorageAdapter({required this.localStorage});

  @override
  Future<String> fetch(String key) async {
    try {
      await localStorage.ready;
      final data = await localStorage.getItem(key);
      return data;
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> save(String key, String value) async {
    try {
      await localStorage.ready;
      return localStorage.setItem(key, value);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
