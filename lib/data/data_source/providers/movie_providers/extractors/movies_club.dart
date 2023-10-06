import 'dart:convert';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/crypto.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'dart:math';

class MoviesClub extends VideoExtractor {
  MoviesClub(super.videoServer);

  @override
  String get name => 'MoviesClub';

  static const _keyV5 = '4VqE3#N7zt&HEP^a';
  static const _keyV2 = "11x&W5UBrcqn\$9Yl";
  static const _keyV3 = "m4H6D9%0\$N&F6rQ&";

  String extractV3(String html, String key) {
    final masterjs = _MasterJs.fromHtmlV3(html);
    return (crypto.aes.decrypt(masterjs.ciphertext, key,
            iv: masterjs.iv,
            options: CipherOptions(salt: masterjs.salt, ivEncoding: 'hex')))
        .convertToString(crypto.enc.utf8)
        .replaceAll('\\n', '\n')
        .replaceAll('\\', '');
  }

  String extractV5(String html, String key) {
    final masterjs = _MasterJs.fromHtmlV3(html);
    final salt = masterjs.salt;
    final iv = masterjs.iv;
    final cipherText = masterjs.ciphertext;

    final derivedKey = crypto.pbkdf2(
        digest: HashAlgorithms.SHA512,
        iterations: 1000,
        // iterations: masterjs.iterations!,
        blockLength: 128,
        keylength: 32,
        salt: crypto.enc.hex.parse(salt),
        key: key);

    return crypto.aes
        .decrypt(cipherText, derivedKey,
            iv: iv,
            options: const CipherOptions(
                textEncoding: 'base64',
                ivEncoding: 'hex',
                padding: Padding.pkc5))
        .convertToString(crypto.enc.utf8);
  }

  String extractV2(String response, String key) {
    final masterjs = _MasterJs.fromHtml(response);

    final salt = masterjs.salt;
    final iv = masterjs.iv;
    final cipherText = masterjs.ciphertext;

    final derivedKey = crypto.pbkdf2(
        digest: HashAlgorithms.SHA512,
        iterations: masterjs.iterations!,
        blockLength: 128,
        keylength: 32,
        salt: crypto.enc.hex.parse(salt),
        key: key);

    return crypto.aes
        .decrypt(cipherText, derivedKey,
            iv: iv,
            options: const CipherOptions(
                textEncoding: 'base64',
                ivEncoding: 'hex',
                padding: Padding.pkc5))
        .convertToString(crypto.enc.utf8);
  }

  String extractWithDynamicKey(String response) {
    final masterjs = _MasterJs.fromHtmlV3(response);
    return (crypto.aes.decrypt(masterjs.ciphertext,
            _DynamicKeyExtractor().getKeyFromHtml(response),
            iv: masterjs.iv,
            options: CipherOptions(salt: masterjs.salt, ivEncoding: 'hex')))
        .convertToString(crypto.enc.utf8)
        .replaceAll('\\n', '\n')
        .replaceAll('\\', '');
  }

  @override
  Future<VideoContainer> extract() async {
    final referer = videoServer.extra!['referer']! as String;
    final response = (await client.get(hostUrl, referer: referer)).text;
    final masterjsVersion =
        RegExp(r'masterjs_v(\d).js').firstMatch(response)?.group(1);

    final String decoded;
    switch (masterjsVersion) {
      case null:
        decoded = extractWithDynamicKey(response);
        break;
      case '3':
        decoded = extractV3(response, _keyV3);
        break;
      case '2':
        decoded = extractV2(response, _keyV2);
        break;
      default:
        decoded = extractV5(response, _keyV5);
        break;
    }
    print(decoded);

    final List<_Source> sources =
        _parseList(RegExp(r'sources: ([^\]]*\])'), decoded, _Source.fromJson)!;

    final List<_Tracks>? tracks =
        _parseList(RegExp(r'tracks: ([^]*?\}\])'), decoded, _Tracks.fromJson)
          ?..removeWhere((it) => it.label == 'thumbnails');

    return VideoContainer(
        videos: sources,
        subtitles: tracks == null || tracks.isEmpty ? null : tracks);
  }

  List<T>? _parseList<T>(
      RegExp regExp, String str, T Function(dynamic json) decoder) {
    final list = regExp.firstMatch(str)?.group(1);
    if (list == null) return null;
    return (json.decode(list) as List).mapAsList(decoder);
  }
}

class _Source extends Video {
  _Source({required String file, required String label, required String type})
      : super(
            fromat: type == 'hls' ? VideoFormat.hls : VideoFormat.mp4,
            quality: label.toLowerCase() == 'auto'
                ? WatchQualites.master
                : Quality.getQuailtyFromString(label),
            url: file);

  factory _Source.fromJson(dynamic json) {
    return _Source(
        file: json['file'] as String,
        type: json['type'] as String,
        label: json['label'] as String);
  }
}

class _Tracks extends Subtitle {
  String get label => lang;

  _Tracks({
    required String file,
    required String label,
  }) : super(url: file, format: Subtitle.getFromatFromUrl(file), lang: label);

  factory _Tracks.fromJson(dynamic json) {
    return _Tracks(
        file: json['file'] as String,
        label: json['label'] as String? ?? 'thumbnails');
  }
}

class _MasterJs {
  final String ciphertext;
  final int? iterations;
  final String iv;
  final String salt;

  _MasterJs(
      {required this.ciphertext,
      this.iterations,
      required this.iv,
      required this.salt});

  factory _MasterJs.fromHtml(String html) {
    final text =
        RegExp(r"MasterJS\s*=\s*'([^']*)'").firstMatch(html)!.group(1)!;
    final json =
        jsonDecode(base64Decode(text).convertToString(crypto.enc.utf8));

    return _MasterJs(
        ciphertext: json['ciphertext'] as String,
        iterations: json['iterations'] as int,
        iv: json['iv'] as String,
        salt: json['salt'] as String);
  }

  factory _MasterJs.fromHtmlV3(String html) {
    final json = jsonDecode(
        RegExp(r"JScript\s*=\s*'([^']*)'").firstMatch(html)!.group(1)!);

    return _MasterJs(
        ciphertext: json['ct'] as String,
        iv: json['iv'] as String,
        salt: json['s'] as String);
  }
}

class _DynamicKeyExtractor {
  String decodeBase(String a, int d, int b) {
    List<String> c =
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/"
            .split("");
    List<String> e = c.sublist(0, d);
    List<String> f = c.sublist(0, b);
    int g = a.split("").reversed.toList().asMap().entries.fold(0, (f, entry) {
      int b = entry.key;
      String g = entry.value;
      if (e.contains(g)) {
        return f += (e.indexOf(g) * pow(d, b)).toInt();
      }
      return f;
    });
    String h = "";
    while (g > 0) {
      h = f[g % b] + h;
      g = (g - g % b) ~/ b;
    }
    return h.isNotEmpty ? h : "0";
  }

  String transfrom(String c, int d, String f, int a, int g, String e) {
    e = "";
    for (int h = 0, k = c.length; h < k; h++) {
      String l = "";
      while (c[h] != f[g]) {
        l += c[h];
        h++;
      }
      for (int m = 0; m < f.length; m++) {
        l = l.replaceAll(RegExp(f[m], multiLine: true), m.toString());
      }
      e += String.fromCharCode(int.parse(decodeBase(l, g, 10)) - a);
    }
    return Uri.decodeFull(Uri.encodeFull(e));
  }

  String getKeyFromHtml(String html) {
    final args = RegExp(r'eval\((.*?)\);')
        .firstMatch(html)!
        .group(1)!
        .substringAfter('(')
        .substringBeforeLast(')')
        .replaceAll('"', '')
        .trim()
        .split(',');

    return RegExp(r"JScript,\s'(.*)'")
        .firstMatch(transfrom(args[0], args[1].toInt(), args[2],
            args[3].toInt(), args[4].toInt(), args[5]))!
        .group(1)!;
  }
}

main() async {
  final a = MoviesClub(VideoServer(
      name: '',
      url: 'https://w1.moviesapi.club/v/hLNMnh7gwLaW/',
      extra: {'referer': 'https://moviesapi.club/'}));

  print(await a.extract());
}
