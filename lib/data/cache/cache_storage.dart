abstract class CacheStorageFetch {
  Future<String> fetch(String key);
}

abstract class CacheStorageSave {
  Future<void> save(String value);
}
