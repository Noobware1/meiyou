import 'package:meiyou/shared/domain/models/link_and_asset.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou_extensions_lib/models.dart';

abstract class MediaAssetLoader<T extends MediaAsset> {
  Stream<List<LinkAndAsset<T>>> getAssetStream(
      Source source, MediaContent content);

  void releaseCache(MediaContent content);

  void releaseAllCache();
}
