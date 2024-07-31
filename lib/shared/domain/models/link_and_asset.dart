import 'package:meiyou_extensions_lib/models.dart';

class LinkAndAsset<T extends MediaAsset> {
  final MediaLink link;
  final T asset;

  const LinkAndAsset({required this.link, required this.asset});
}
