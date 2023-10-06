import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/js_unpacker.dart';
import 'package:meiyou/core/resources/quailty.dart';
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
          quality: Quality.getQuailtyFromString(
              videoServer.extra!['quality'] as String),
          fromat: Video.getFormatFromUrl(url)),
    ]);
  }

  @override
  String get name => "Kwik";
}

class _Packed {
  final String p;
  final String a;
  final String c;
  final String k;
  final String e;
  final String d;

  _Packed(this.p, this.a, this.c, this.k, this.e, this.d);

  factory _Packed.FromIterable(List<String> iterable) {
    assert(iterable.length == 6);
    return _Packed(iterable[0], iterable[1], iterable[2], iterable[3],
        iterable[4], iterable[5]);
  }
}

void main(List<String> args) {
  Kwik(const VideoServer(url: 'https://kwik.cx/e/fDWLwOdx3p0i', name: '', extra: {
    'referer': 'https://animepahe.ru/',
    'quality': Quality(pixel: 0, quaility: 0)
  })).extract().then((value) => print(value));
}
