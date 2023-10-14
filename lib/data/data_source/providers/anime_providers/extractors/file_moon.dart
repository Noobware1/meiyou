import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/js_unpacker.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class FileMoon extends VideoExtractor {
  FileMoon(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    final packed =
        packedRegex.allMatches((await client.get(hostUrl)).text).last.group(1);

    final file = RegExp(r'file:"([^"]*)"')
        .firstMatch(JSPacker(packed!).unpack()!)!
        .group(1)!;


    return VideoContainer(videos: [Video.hlsMaster(file)]);
  }

  @override
  String get name => 'FileMoon';

  final packedRegex = RegExp(r'<script[^>]*>(eval[\s\S]*?)</script>');
}
