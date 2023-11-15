import 'package:meiyou/domain/entities/media_type.dart';

class MediaEntity {
  MediaType? mediaType;
  Map<String, String>? headers;
  Map<String, dynamic>? extra;

  MediaEntity({this.mediaType, this.headers, this.extra});
}
