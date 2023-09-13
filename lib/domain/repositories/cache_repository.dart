abstract interface class CacheRespository {
  void addMemoryCache(String key, {required Object data});

  void removeMemoryCache(String key);

  T? getFromMemoryCache<T>(String key);

  void updateMemoryCacheValue(String key, Object value);

  Future<void> addIOCache(String path, String data);

  Future<void> removeIOCache(String path);

  Future<T?> getFromIOCache<T>(
      String path, T Function(dynamic data) transfromer);

  Future<void> updateIOCacheValue(String path, String value);

  Future<void> deleteAllIOCache();

  void deleteAllMemoryCache();

  Future<void> deleteAllCache();
}
