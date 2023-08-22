import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/core/utils/m3u8_parser/models/m3u8_file_data.dart';
import 'package:meiyou/core/utils/m3u8_parser/models/m3u8_stream.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

final base64Regex = RegExp(
    r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$');
final _resoultionRegex = RegExp(r'RESOLUTION=(\d+)x(\d+)');

class M3u8Parser {
  static Future<VideoContainer> generateVideoContainer(
    String url, {
    Map<String, String>? headers,
    List<Subtitle>? subtitles,
  }) async {
    final parsed = await parse(url, headers: headers);
    return VideoContainer(
        videos: parsed
            .map(
              (it) => Video(
                url: it.url,
                quality: it.quality,
                fromat: VideoFormat.hls,
              ),
            )
            .toList(),
        subtitles: subtitles,
        headers: headers);
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

  List<String> parseM3u8FileData(String mainUrl, String m3u8File) {
    final lines = LineSplitter.split(m3u8File).toList();
    final videoUrls = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].endsWith('.txt') ||
          lines[i].endsWith('.html') ||
          lines[i].endsWith('.ts')) {
        videoUrls.add(_fixUrl(mainUrl, lines[i]));
      }
    }
    return videoUrls;
  }

  static List<M3u8File> parseMaster(String mainUrl, String master) {
    List<Quality> quailites = [];
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
//   Future<void> downloadMp4({required String savePath, required List<String> videoUrls}) async {
//     // final splitList = _splitList(videoUrls);
//     final mp4 = File(savePath);
//     final file = mp4.openSync(mode: FileMode.write);
//     file.close();

// for(var i = 0; i < videoUrls.length; i++) {
//   await Dio().download(videoUrls[i], savePath)
// }
//   }

//   List<List<T>> _splitList<T>(List<T> list) {
//     int elementsPerPart = (list.length / 4).ceil();
//     final List<List<T>> result = [];
//     for (int i = 0; i < list.length; i += elementsPerPart) {
//       int end = i + elementsPerPart;
//       result.add(list.sublist(i, end > list.length ? list.length : end));
//     }
//     return result;
//   }
}

Quality parseResolution(String resoultionString) {
  final group = _resoultionRegex.firstMatch(resoultionString)!.groups([1, 2]);

  return Quality(pixel: group[0]!.toInt(), quaility: group[1]!.toInt());
}

String _isBase64Encoded(String str) {
  if (base64Regex.hasMatch(str)) {
    str = str.decodeBase64();
  }
  return str;
}

String _fixUrl(String mainUrl, String url) {
  if (url.startsWith('http')) return url;
  return '$mainUrl/$url';
}
