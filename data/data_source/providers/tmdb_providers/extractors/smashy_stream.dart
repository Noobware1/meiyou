import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class SmashyStreamExtractor extends VideoExtractor {
  SmashyStreamExtractor(super.videoServer);

  @override
  String get name => '[${videoServer.name}]';

  @override
  Future<VideoContainer> extract() {
    if (hostUrl.contains('fiz') || hostUrl.contains('segu')) {
      // print('fizzzzzzzzzz');
      return _extractFizz();
    } else if (hostUrl.contains('fm')) {
      return _exractFm();
    } else if (hostUrl.contains('ems')) {
      return _extractEms();
    } else {
      throw Exception('Cannot extract $hostUrl');
    }
  }

  // String videoServer.referer => videoServer.extra!['referer'] as String;

  Future<VideoContainer> _extractFizz() {
    return client
        .get(videoServer.url, referer: videoServer.referer)
        .then((response) {
      // print(response.text);
      final json = jsonDecode(
          '{"file${RegExp(r'\((\{[^;]*\})\);').firstMatch(response.text)!.group(1)!.substringAfter('"file')}');
      final List<Video> files = [];
      final List<Subtitle> subtitles = [];

      if (((json['file'] as String).contains('[auto]'))) {
        files.add(_utils.toVideo(_utils.strToList(json
            .toString()
            .split(',')
            .firstWhere((it) => it.contains('auto')))));
      } else {
        json['file']
            .toString()
            .split(',')
            .where((it) => it.isNotEmpty)
            .forEach((it) {
          files.add(_utils.toVideo(_utils.strToList(it)));
        });
      }

      (json['subtitle'] as String?)
          ?.split(',')
          .where((it) => it.isNotEmpty)
          .forEach((it) {
        subtitles.add(_utils.toSubtitle(_utils.strToList(it)));
      });

      return VideoContainer(videos: files, subtitles: subtitles);
    });
  }

  Future<VideoContainer> _exractFm() {
    return client
        .get(videoServer.url, referer: videoServer.referer)
        .then((response) {
      var data = RegExp(r'\((\{[^;]*),\s\}\);')
          .firstMatch(response.text)!
          .group(1)!
          .substringAfter('file');
      if (data.contains('subtitle')) {
        data = data.replaceFirst('subtitle', '"subtitle"');
      }
      data = '{"file"$data}';

      final List<Subtitle> subtitles = [];

      final json = jsonDecode(data);

      (json['subtitle'] as String?)
          ?.split(',')
          .where((it) => it.isNotEmpty)
          .forEach((it) {
        subtitles.add(_utils.toSubtitle(_utils.strToList(it)));
      });

      return VideoContainer(
          videos: [Video.hlsMaster(json['file'].toString())],
          subtitles: subtitles);
    });
  }

  Future<VideoContainer> _extractEms() {
    return _extractServer((response) {
      final json = jsonDecode(
          '{"file${RegExp(r'\((\{[^;]*)\);').firstMatch(response.text)!.group(1)!.substringAfter('"file')}');
      final List<Subtitle> subtitles = [];

      (json['subtitle'] as String?)
          ?.split(',')
          .where((it) => it.isNotEmpty)
          .forEach((it) {
        subtitles.add(_utils.toSubtitle(_utils.strToList(it)));
      });

      return VideoContainer(videos: [
        Video.hlsMaster(
          json['file'].toString(),
        )
      ], subtitles: subtitles);
    });
  }

  // _extractSE() {
  //   return _extractServer((response) {});
  // }

  Future<VideoContainer> _extractServer(
          VideoContainer Function(OkHttpResponse response) extract) =>
      client
          .get(hostUrl, referer: videoServer.referer)
          .then((response) => extract(response));

  final _utils = _ExtractorUtils();
}

class _ExtractorUtils {
  List<String> strToList(String str) {
    return str.replaceFirst('[', '').replaceFirst(',', '').split(']');
  }

  Video toVideo(List<String> lst) {
    return Video(
        url: lst[1],
        quality: lst[0].toLowerCase() == 'auto'
            ? Qualites.master
            : Qualites.getFromString(lst[0]),
        fromat: VideoFormat.hls);
  }

  Subtitle toSubtitle(List<String> lst) {
    return Subtitle.withSubtitleFromatFromUrl(lst[1], lst[0]);
  }
}
