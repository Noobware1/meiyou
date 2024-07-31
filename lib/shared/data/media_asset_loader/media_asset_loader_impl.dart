import 'package:meiyou/core/utils/exceptions/no_asset_exception.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/shared/domain/media_asset_loader/media_asset_loader.dart';
import 'package:meiyou/shared/domain/models/link_and_asset.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaAssetLoaderImpl<T extends MediaAsset> extends MediaAssetLoader<T> {
  final Map<int, List<LinkAndAsset<T>>> _cache = {};

  @override
  Stream<List<LinkAndAsset<T>>> getAssetStream(
      Source source, MediaContent content) async* {
    final id = content.id;
    if (_cache[id] != null) {
      yield _cache[id]!;
      return;
    }
    final linkResults =
        await runAsyncCatching(() => source.getMediaLinkList(content));
    if (linkResults.isFailure) {
      yield* Stream.error(linkResults.exceptionOrNull()!, StackTrace.current);
      return;
    }
    final links = linkResults.getOrThrow();

    bool isEmpty = true;
    for (var link in links) {
      final assetResult =
          await runAsyncCatching(() => source.getMediaAsset(link));

      if (assetResult.isFailure) {
        yield* Stream.error(assetResult.exceptionOrNull()!, StackTrace.current);
        return;
      }

      final asset = assetResult.getOrThrow();

      if (asset == null) continue;

      if (asset is! T) {
        yield* Stream.error(
          Exception(
              'Asset type mismatch: expected $T, got ${asset.runtimeType}'),
          StackTrace.current,
        );
        continue;
      }

      isEmpty = false;

      _cache
          .putIfAbsent(id, () => [])
          .add(LinkAndAsset(link: link, asset: asset));

      yield _cache[id]!;
    }

    if (isEmpty) {
      yield* Stream.error(const NoAssetException(), StackTrace.current);
    }
  }

  @override
  void releaseCache(MediaContent content) {
    _cache.remove(content.id);
  }

  @override
  void releaseAllCache() {
    _cache.clear();
  }
}
