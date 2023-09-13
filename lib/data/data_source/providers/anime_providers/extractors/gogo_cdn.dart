import 'dart:convert';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/crypto.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class GogoCDN extends VideoExtractor {
  GogoCDN(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    final doc = (await client.get(hostUrl)).document;
    final script =
        doc.selectFirst('script[data-name="episode"]').attr('data-value');
    final id = doc.selectFirst('#id').attr('value');
    final host = Uri.parse(hostUrl).host;
    final encryptedID = _cryptoHandler(_keysAndIV.key, _keysAndIV.iv, id, true);
    final decryptedID = _cryptoHandler(_keysAndIV.key, _keysAndIV.iv, script)
        .replaceFirst(id, encryptedID);

    final encryptedData = (await client.get(
            'https://$host/encrypt-ajax.php?id=$decryptedID&alias=$id',
            headers: {'x-requested-with': 'XMLHttpRequest'}))
        .json((json) => json['data'] as String);

    final decryptedData = _SourceResponse.fromJson(jsonDecode(
        _cryptoHandler(_keysAndIV.secondKey, _keysAndIV.iv, encryptedData)));

    final List<Video> list = [];

    Future<void> addVideo(_Source source, [bool? backup]) async {
      final label = source.label.toLowerCase();
      final url = source.file;
      if (label != "auto p" && label != "hls p") {
        list.add(Video(
          url: url,
          quality: Quality.getQuailtyFromString(label),
          fromat: VideoFormat.other,
          backup: backup ?? false,
        ));
      } else {
        list.add(Video(
          url: url,
          quality: WatchQualites.master,
          fromat: VideoFormat.hls,
          backup: backup ?? false,
        ));
      }
    }

    final headers = {'referer': 'https://$host'};

    for (final e in decryptedData.source) {
      await addVideo(e);
    }
    if (decryptedData.backup != null) {
      for (final e in decryptedData.backup!) {
        await addVideo(e, true);
      }
    }

    return VideoContainer(videos: list, headers: headers);
  }

  @override
  String get name => 'GogoCDN';

  static const _keysAndIV = _Keys('37911490979715163134003223491201',
      '54674138327930866480207815084989', '3134003223491201');

  String _cryptoHandler(String key, String iv, String text,
      [bool encrypt = false]) {
    final options = CipherOptions(
        ivEncoding: 'utf8',
        keyEncoding: 'utf8',
        textEncoding: encrypt ? 'utf8' : 'base64');
    if (encrypt) {
      return crypto.aes.encrypt(text, key, iv: iv, options: options).toString();
    } else {
      return crypto.aes
          .decrypt(text, key, iv: iv, options: options)
          .convertToString(crypto.enc.utf8);
    }
  }
}

class _Keys {
  final String key;
  final String secondKey;
  final String iv;

  const _Keys(this.key, this.secondKey, this.iv);
}

class _SourceResponse {
  final List<_Source> source;
  final List<_Source>? backup;

  _SourceResponse(this.source, this.backup);

  factory _SourceResponse.fromJson(dynamic json) {
    return _SourceResponse(
      (json['source'] as List).mapAsList(_Source.fromJson),
      (json['source_bk'] as List?)?.mapAsList(_Source.fromJson),
    );
  }
}

class _Source {
  final String file;
  final String label;
  final String type;

  _Source({required this.label, required this.file, required this.type});

  factory _Source.fromJson(dynamic json) {
    return _Source(
        label: json['label'], file: json['file'], type: json['type']);
  }
}
