import 'package:meiyou/data/models/media/video/video_format.dart';
import 'package:meiyou/data/models/media/video/video_quailty.dart';

class VideoSource {
  String url;
  VideoFormat format;
  VideoQuality? quality;
  bool isBackup;
  String? title;

  VideoSource({
    this.url = '',
    this.format = VideoFormat.other,
    this.quality,
    this.title,
    this.isBackup = false,
  });

  @override
  String toString() {
    return '''VideoSource({
      url: $url,
      format: $format,
      quality: $quality,
      title: $title,
      isBackup: $isBackup,
    })''';
  }
}

