import 'dart:convert';
import 'dart:io';

import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/utils/extenstions/directory.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

class CacheRepositoryImpl implements CacheRespository {
  final Map<String, Object> _cache = {};
  late final String _cacheDir;

  CacheRepositoryImpl(String cacheDir) : _cacheDir = cacheDir;

  @override
  void addMemoryCache(String key, {required Object data}) {
    _cache[key] = data;
  }

  @override
  void deleteAllMemoryCache() {
    _cache.clear();
  }

  @override
  void updateMemoryCacheValue(String key, Object value) {
    try {
      _cache.update(key, (_) {
        return value;
      });
    } catch (_) {}
    // remove(key);
    // add(key, data: value);
  }

  @override
  T? getFromMemoryCache<T>(String key) {
    if (!_cache.containsKey(key)) return null;
    return _cache[key] as T;
  }

  @override
  void removeMemoryCache(String key) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }
  }

  @override
  Future<void> addIOCache(String path, String data) async {
    final file = File(_appendCacheDir(path));
    print(file.path);
    if (file.existsSync()) {
      throw MeiyouException(
          'file alreadys exists in ${_appendCacheDir(path)}, use updateIOCacheValue() to update it or use remove it with removeIOCache()');
    } else {
      await file.create();
      //   file.writeAsString(data);
      await file.writeAsString(data, flush: true);

      print('data written successfully');
    }
  }

  @override
  Future<void> deleteAllIOCache() async {
    final dir = Directory(_cacheDir);
    if (await dir.exists()) {
      await for (var entity in dir.list()) {
        if (entity is File) {
          await entity.delete();
        }
      }
    }
  }

  @override
  Future<void> deleteIOCacheFromDir(String path) async {
    Directory(_appendCacheDir(path)).deleteAllEntries();

    // if (await dir.exists()) {
    //   await for (var entity in dir.list()) {
    //     if (entity is File) {
    //       await entity.delete();
    //     }
    //   }
    // }
  }

  @override
  Future<T?> getFromIOCache<T>(
      String path, T Function(dynamic data) transfromer) async {
    final file = File(_appendCacheDir(path));
    if (!file.existsSync()) return null;
    // throw MeiyouException(
    //     'File doesn\'t exists in FileSystem on path ${_appendCacheDir(path)}, use addIOCache() to create the file first');

    return transfromer.call(json.decode(await file.readAsString()));
  }

  @override
  Future<void> removeIOCache(String path) async {
    final file = File(_appendCacheDir(path));
    if (!file.existsSync()) {
      throw MeiyouException(
          'File doesn\'t exists in FileSystem on path ${_appendCacheDir(path)}, use addIOCache() to create the file first');
    }
    await file.delete();
  }

  @override
  Future<void> updateIOCacheValue(String path, String value) async {
    final file = File(_appendCacheDir(path));

    if (!file.existsSync()) {
      throw MeiyouException(
          'file doesn\'t exists in ${_appendCacheDir(path)}, use addIOCache() to create it');
    } else {
      await file.writeAsString(value, flush: true);

      print('data written successfully');
    }
  }

  @override
  Future<void> deleteAllCache() async {
    deleteAllMemoryCache();
    await deleteAllIOCache();
  }

  String _appendCacheDir(String path) => '$_cacheDir/$path';
}
