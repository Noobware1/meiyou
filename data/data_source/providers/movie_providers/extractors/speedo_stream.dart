import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class SpeedoStreamExtractor extends VideoExtractor {
  @override
  String get name => 'SpeedoStream';

  SpeedoStreamExtractor(super.server);

  @override
  Future<VideoContainer> extract() async {
    final text = (await client.get(hostUrl, referer: videoServer.referer)).text;
    final RegExp fileRegex = RegExp(r'sources:\s\[{file:"(.*)"}\]');

    return VideoContainer(
        videos: [Video.hlsMaster(fileRegex.firstMatch(text)!.group(1)!)]);
  }
}
