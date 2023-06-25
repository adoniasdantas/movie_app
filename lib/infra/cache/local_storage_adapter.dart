import 'package:localstorage/localstorage.dart';

import 'package:movie_app/data/cache/cache.dart';

import 'package:movie_app/domain/errors/errors.dart';

class LocalStorageAdapter implements CacheStorageFetch {
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