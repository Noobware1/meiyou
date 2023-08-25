import 'package:meiyou/domain/repositories/cache_repository.dart';

class CacheRepositoryImpl implements CacheRespository {
  final Map<String, Object> _cache = {};

  @override
  void add(String key, {required Object data}) {
    _cache[key] = data;
  }

  @override
  void deleteAllCache() {
    _cache.clear();
  }

  @override
  void update(String key, Object value) {
    remove(key);
    add(key, data: value);
  }

  @override
  T? get<T>(String key) {
    if (!_cache.containsKey(key)) return null;
    return _cache[key] as T;
  }

  @override
  void remove(String key) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }
  }
}
