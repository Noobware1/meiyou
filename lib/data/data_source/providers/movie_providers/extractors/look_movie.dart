import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class LookMovieExtractor extends VideoExtractor {
  LookMovieExtractor(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    return client
        .get(hostUrl, cookie: videoServer.extra!['cookie'] as String)
        .then((response) {
      return response.json((json) => _LookMovieVideoResponse.fromJson(
          json,
          videoServer.extra!['url'] as String,
          {'cookie': videoServer.extra!['cookie'] as String}));
    });
  }

  @override
  String get name => 'LookMovie-Main';
}

class _Streams extends Video {
  _Streams({required super.url, required String quailty})
      : super(
            fromat: Video.getFormatFromUrl(url),
            quality: Quality.getQuailtyFromString(quailty));

  factory _Streams.fromMapEntry(MapEntry entry) {
    return _Streams(url: entry.value, quailty: entry.key);
  }
}

class _Subtitles extends Subtitle {
  _Subtitles({required super.url, required super.lang})
      : super(format: Subtitle.getFromatFromUrl(url));

  factory _Subtitles.fromJson(dynamic json, String hostUrl) {
    return _Subtitles(
        url: hostUrl + json['file'].toString(), lang: json['language']);
  }
}

class _LookMovieVideoResponse extends VideoContainer {
  const _LookMovieVideoResponse(
      {required super.videos, super.subtitles, super.headers});

  factory _LookMovieVideoResponse.fromJson(
      Map json, String hostUrl, Map<String, String> headers) {
    final videos = <Video>[];
    final List<Subtitle>? subtitles;
    for (final video in (json['streams'] as Map).entries) {
      videos.add(_Streams.fromMapEntry(video));
    }

    if (json['subtitles'] != null && (json['subtitles'] as List).isNotEmpty) {
      subtitles = [];
      for (final subtitle in (json['subtitles'])) {
        subtitles.add(_Subtitles.fromJson(subtitle, hostUrl));
      }
    } else {
      subtitles = null;
    }

    return _LookMovieVideoResponse(
        videos: videos, headers: headers, subtitles: subtitles);
  }
}


