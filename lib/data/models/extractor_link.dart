import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/domain/entities/extractor_link.dart';

class ExtractorLink extends ExtractorLinkEntity {
  ExtractorLink({
    required super.name,
    required super.url,
    super.headers,
    super.referer,
    super.extra,
  });

  @override
  String toString() {
    return '''ExtractorLink(
      name: $name,
      url: $url,
      headers: $headers,
      referer: $referer,
      extra: $extra,
    )''';
  }

  factory ExtractorLink.fromEntity(ExtractorLinkEntity entity) {
    return createFromEntity<ExtractorLinkEntity, ExtractorLink>(
        entity,
        ExtractorLink(
          name: entity.name,
          url: entity.url,
          headers: entity.headers,
          referer: entity.referer,
          extra: entity.extra,
        ));
  }
}
