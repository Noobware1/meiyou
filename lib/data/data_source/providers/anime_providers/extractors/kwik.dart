import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/js_unpacker.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';

class Kwik extends VideoExtractor {
  Kwik(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    final res = await client.get(hostUrl, headers: {
      'Referer': videoServer.extra!['referer'] as String,
    });

    final String url = RegExp(r"source\='([^}]*)';")
        .firstMatch(JsUnpack(RegExp(r'(eval)(\(f.*?)(\n<\/script>)')
                .firstMatch(res.text)!
                .group(2)!)
            .unpack())!
        .group(1)!;

    return VideoContainer(videos: [
      Video(
          url: url,
          quality:
              Qualites.getFromString(videoServer.extra!['quality'] as String),
          fromat: Video.getFormatFromUrl(url)),
    ]);
  }

  @override
  String get name => "Kwik";
}


