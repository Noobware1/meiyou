abstract interface class CacheRespository {
  void add(String key, {required Object data});

  void remove(String key);

  T? get<T>(String key);

  void update(String key, Object value);

  void deleteAllCache();
}
