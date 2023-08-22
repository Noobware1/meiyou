import 'dart:convert';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/crypto.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/m3u8_parser/m3u8_parser.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class RapidCloud extends VideoExtractor {
  RapidCloud(super.videoServer);


  String getUrl() {
    final serverUrl = videoServer.url;
    final embed = RegExp(r'embed-\d').firstMatch(serverUrl)?.group(0);
    final id = serverUrl.substringAfterLast("/").substringBefore("?");

    final e = RegExp(r'e-\d').firstMatch(serverUrl)!.group(0);
    return '$hostUrl/$embed/ajax/$e/getSources?id=$id';
  }

  @override
  Future<VideoContainer> extract() async {
    final serverUrl = videoServer.url;
    final jsonLink = getUrl();

    final response = (await client.get(jsonLink, headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Referer': serverUrl,
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
    }))
        .json();

    final List<_Source> sources;

    if (response['encrypted'] == false) {
      sources =
          (response['sources'] as List).mapAsList((it) => _Source.fromJson(it));
    } else {
      final decryptKey = await _decryptKey();
      List<String> sourcesArray = (response['sources'] as String).split("");
      var extractedKey = "";

      for (final index in decryptKey) {
        for (var i = index[0]; i < index[1]; i++) {
          extractedKey += sourcesArray[i];
          sourcesArray[i] = "";
        }
      }

      final decrypted = crypto.aes
          .decrypt(sourcesArray.join(''), extractedKey)
          .convertToString(crypto.enc.utf8);

      sources = (jsonDecode(decrypted) as List)
          .mapAsList((it) => _Source.fromJson(it));
    }

    final List<_Tracks> tracks = (response['tracks'] as List)
        .mapAsList((it) => _Tracks.fromJson(it))
      ..removeWhere((it) => it.label == 'thumbnails');

    final List<Video> videos = [];
    for (var i = 0; i < sources.length; i++) {
      videos.addAll(await M3u8Parser.generateVideos(sources[i].url));
    }

    return VideoContainer(
      videos: videos,
      subtitles: tracks,
    );
  }

  @override
  String get hostUrl => videoServer.url.substringBefore('/embed');

  @override
  String get name => 'RapidCloud';

  String get keyUrl =>
      'https://raw.githubusercontent.com/enimax-anime/key/e6/key.txt';

  Future<List<List<int>>> _decryptKey() async {
    return (await client.get(keyUrl)).json((json) => (json as List)
        .mapAsList((it) => (it as List).mapAsList((it) => it as int)));
  }
}

class _Source {
  final String url;
  late final VideoFormat format;
  _Source({required this.url, required String type}) {
    type == 'hls' ? format = VideoFormat.hls : format = VideoFormat.mp4;
  }

  factory _Source.fromJson(dynamic json) {
    return _Source(url: json['file'], type: json['type']);
  }
}

class _Tracks extends Subtitle {
  String get label => lang;

  _Tracks({required super.url, required String label})
      : super(format: Subtitle.getFromatFromUrl(url), lang: label);

  factory _Tracks.fromJson(dynamic json) {
    return _Tracks(
        url: json['file'] as String,
        label: json['label'] as String? ?? 'thumbnails');
  }
}
