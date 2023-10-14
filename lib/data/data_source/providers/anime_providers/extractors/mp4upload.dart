import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class Mp4Upload extends VideoExtractor {
  Mp4Upload(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    final text = (await client.get(hostUrl)).text;
    return VideoContainer(videos: [
      Video(
          url: RegExp(r'src:\s"([^"]*)"').firstMatch(text)!.group(1)!,
          quality: Qualites.unknown,
          fromat: RegExp(r'type:\s"([^"]*)"')
                      .firstMatch(text)
                      ?.group(1)
                      ?.contains('mp4') ==
                  true
              ? VideoFormat.mp4
              : VideoFormat.other)
    ]);
  }

  @override
  String get name => 'Mp4Cloud';
}
