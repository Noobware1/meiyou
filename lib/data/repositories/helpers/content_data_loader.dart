import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LinkAndData<T extends ContentData> = Pair<ContentDataLink, T>;

class ContentDataLoader<T extends ContentData> {
  static const maxCacheSize = 100;

  final SourceRepository _sourceRepository = InjectKtor.get();
  final Map<String, List<LinkAndData<T>>> _cache = {};

  Stream<List<LinkAndData<T>>> getContentDataStream(
      Source source, String url) async* {
    if (_cache[url] != null) yield _cache[url]!;
    final links = await _sourceRepository.getDataLinks(source, url);
    if (links.isFailure) {
      yield* Stream.error(links.exceptionOrNull()!);
    }
    for (var link in links.getOrNull()!) {
      final data = await _sourceRepository.getContentData<T>(source, link);
      if (data.isFailure) {
        logRat.logError('Failed to load content data', data.exceptionOrNull());
        continue;
      }
      final linkAndData = Pair(link, data.getOrNull()!);

      _cache.putIfAbsent(url, () {
        if (_cache.length >= maxCacheSize) {
          _cache.remove(_cache.keys.first);
        }
        return [];
      }).add(linkAndData);
      yield _cache[url]!;
    }
  }

  void clearCache() {
    _cache.clear();
  }
}


