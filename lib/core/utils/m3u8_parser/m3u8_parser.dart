import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';

import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/m3u8_parser/models/m3u8_stream.dart';
import 'package:meiyou/data/models/media/video/subtitle.dart';
import 'package:meiyou/data/models/media/video/video.dart';
import 'package:meiyou/data/models/media/video/video_format.dart';
import 'package:meiyou/data/models/media/video/video_quailty.dart';
import 'package:meiyou/data/models/media/video/video_source.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

final base64Regex = RegExp(
    r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$');
final _resoultionRegex = RegExp(r'RESOLUTION=(\d+)x(\d+)');

class M3u8Parser {
  static Future<Video> generateVideoContainer(
    String url, {
    Map<String, String>? headers,
    bool? backup,
    List<Subtitle>? subtitles,
  }) async {
    final videos = await generateVideos(url, headers: headers, backup: backup);

    return Video(
        videoSources: videos, headers: headers, subtitles: subtitles);
  }

  static Future<List<VideoSource>> generateVideos(
    String url, {
    bool? backup,
    Map<String, String>? headers,
  }) async {
    final parsed = await parse(url, headers: headers);
    return parsed.mapAsList(
      (it) => VideoSource(
        url: it.url,
        quality: it.quality,
        isBackup: backup ?? false,
        format: VideoFormat.hls,
      ),
    );
  }

  static Future<List<M3u8File>> parse(
    String url, {
    Map<String, String>? headers,
  }) async {
    final mainUrl = url.substringBeforeLast('/');
    final response = await client.get(url, headers: headers);
    final master = _isBase64Encoded(response.text);
    final parsed = parseMaster(mainUrl, master);
    return parsed;
  }

  List<String> parseM3u8FileData(String url, String m3u8File) {
    final mainUrl = url.substringBeforeLast('/');
    final lines = LineSplitter.split(m3u8File).toList();

    final videoUrls = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].isNotEmpty &&
          (!lines[i].startsWith('#') || lines[i].endsWith('.ts'))) {
        videoUrls.add(_fixUrl(mainUrl, lines[i]));
      }
    }
    return videoUrls;
  }

  static List<M3u8File> parseMaster(String mainUrl, String master) {
    List<VideoQuality> quailites = [];
    List<String> urls = [];
    LineSplitter.split(master).forEach((it) {
      if (it.startsWith('#EXT-X-STREAM')) {
        quailites.add(parseResolution(it));
      } else if (it.isNotEmpty && !it.startsWith('#')) {
        urls.add(_fixUrl(mainUrl, it));
      }
    });

    if (quailites.isEmpty || urls.isEmpty || quailites.length != urls.length) {
      throw StateError('Could not parse the m3u8');
    }

    return List.generate(quailites.length,
        (index) => M3u8File(url: urls[index], quality: quailites[index]));
  }

//In the future maybe
  Future<int> downloadMp4FromM3u8(
      {required String savePath,
      required List<String> segements,
      void Function(double recevied, double total)? onReceiveProgress}) async {
    final mp4 = File('$savePath.mp4');

    return download(
        file: mp4, urls: segements, onReceiveProgress: onReceiveProgress);
  }

  Future<int> download(
      {required File file,
      bool deleteOnError = true,
      void Function(double recevied, double total)? onReceiveProgress,
      required List<String> urls}) async {
    final clnt = client.createClient();
    try {
      final total = urls.length;
      for (var i = 0; i < total; i++) {
        final recevied = (i / urls.length) * 100;
        await downloader(
            client: clnt, file: file, url: urls[i], deleteOnError: true);

        onReceiveProgress?.call(recevied, total.toDouble());
      }
      print('downloaded successfully');
      return 0;
    } catch (_) {
      print(_);
      print('downloaded failed');
    } finally {
      clnt.close();
    }
    return 1;
  }
}

VideoQuality parseResolution(String resoultionString) {
  final group = _resoultionRegex.firstMatch(resoultionString)!.groups([1, 2]);

  return VideoQuality.getFromString('${group[0]!}x{$group[1]!}');
}

String _isBase64Encoded(String str) {
  if (base64Regex.hasMatch(str)) {
    str = String.fromCharCodes(str.decodeBase64());
  }
  return str;
}

String _fixUrl(String mainUrl, String url) {
  if (url.startsWith('http')) return url;
  return '$mainUrl/$url';
}
