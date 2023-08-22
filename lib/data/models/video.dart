import 'package:meiyou/domain/entities/video.dart';

class Video extends VideoEntity {
  const Video(
      {required super.url,
      required super.quality,
      required super.fromat,
       super.extra,
      super.title});
}
