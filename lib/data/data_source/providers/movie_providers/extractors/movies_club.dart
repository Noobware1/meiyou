import 'dart:convert';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/crypto.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class MoviesClub extends VideoExtractor {
  MoviesClub(super.videoServer);

  @override
  String get name => 'MoviesClub';

  static const _keyV5 = '4VqE3#N7zt&HEP^a';
  static const _keyV2 = "11x&W5UBrcqn\$9Yl";
  static const _keyV3 = "m4H6D9%0\$N&F6rQ&";

  extractV3(String html) {
    final masterjs = _MasterJs.fromHtmlV3(html);

    crypto.aes.decrypt(masterjs.ciphertext, _keyV3,
        iv: masterjs.iv, options: CipherOptions(salt: masterjs.salt, ivEncoding: 'hex'));
  }

  @override
  Future<VideoContainer> extract() async {
    final referer = videoServer.extra!['referer']! as String;
    final masterjsVersion = videoServer.extra!['v'] as int? ?? 2;
    final response = (await client.get(hostUrl, referer: referer)).text;
    final masterjs = _MasterJs.fromHtml(response);

    final salt = masterjs.salt;
    final iv = masterjs.iv;
    final cipherText = masterjs.ciphertext;

    final derivedKey = crypto.pbkdf2(
        digest: crypto.digestNames.SHA512,
        iterations: masterjs.iterations!,
        blockLength: 128,
        keylength: 32,
        salt: crypto.enc.hex.parse(salt),
        key: masterjsVersion != 2 ? _keyV5 : _keyV2);

    final decoded = crypto.aes
        .decrypt(cipherText, derivedKey,
            iv: iv,
            options: const CipherOptions(
                textEncoding: 'base64',
                ivEncoding: 'hex',
                padding: Padding.pkc5))
        .convertToString(crypto.enc.utf8);

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
            quality: Quality.getQuailtyFromString(label),
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
        RegExp(r"MasterJS\s*=\s*'([^']*)'").firstMatch(html)!.group(1)!);

    return _MasterJs(
        ciphertext: json['ct'] as String,
        iv: json['iv'] as String,
        salt: json['s'] as String);
  }
}
