import 'package:meiyou_extenstions/models.dart';

class LinkAndSourceEntity {
  final ExtractorLink link;
  final VideoSource source;

  const LinkAndSourceEntity({required this.link, required this.source});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkAndSourceEntity &&
          link == other.link &&
          source == other.source;

  @override
  int get hashCode => link.hashCode ^ source.hashCode;
}
