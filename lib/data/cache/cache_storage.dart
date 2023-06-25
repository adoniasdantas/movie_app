abstract class CacheStorage {
  Future<String> fetch(String key);
  Future<void> save(String value);
}
