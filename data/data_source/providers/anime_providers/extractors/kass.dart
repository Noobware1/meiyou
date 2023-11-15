import 'dart:convert';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:meiyou/core/constants/user_agent.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/crypto.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';

_getHostUrl(String url) {
  final uri = Uri.parse(url);
  return '${uri.scheme}://${uri.host}';
}

class KickAssExtractor extends VideoExtractor {
  KickAssExtractor(super.videoServer);

  @override
  String get name => 'KassExtractor';

  late final _hostUrl = _getHostUrl(videoServer.url);

  @override
  String get hostUrl => _hostUrl;

  @override
  Future<VideoContainer> extract() async {
    final text = (await client.get(videoServer.url, headers: {
      'User-Agent': USERAGENT,
    }))
        .text;
    print(text);
    final shortName = videoServer.extra!['shortName'];
    final params = _Params.fromConfig(
        _PlayerConfig.fromString(configRegex.firstMatch(text)!.group(1)!));
    var key = '';
    try {
      key = (await client.get(
              'https://raw.githubusercontent.com/enimax-anime/kaas/$shortName/key.txt'))
          .text;
    } catch (_) {
      key = (await client.get(
              'https://raw.githubusercontent.com/enimax-anime/kaas/duck/key.txt'))
          .text;
    }
    final bool isBirb = shortName == 'bird';
    final encryptedParams = await params.getEnctrypedParams(shortName, key);
    print(
        '$hostUrl${params.route}?${params.mid}${isBirb ? "" : "&e=${params.timestamp}"}&s=$encryptedParams');
    // final results = await client.get(
    //     '$hostUrl${params.route}?${params.mid}${isBirb ? "" : "&e=${params.timestamp}"}&s=$encryptedParams',
    //     referer: videoServer.url,
    //     headers: {'User-Agent': USERAGENT});
    // print(results.text);
    throw UnimplementedError();
  }

  final configRegex = RegExp(r'playerConfig\s=\s({[^;]*})');
}

class _Params {
  final String signature;
  final int timestamp;
  final String route;
  final String ip;
  final bool usesMid;
  // final String userAegent;
  final String mid;

  _Params({
    required this.signature,
    required this.timestamp,
    required this.route,
    required this.ip,
    required this.usesMid,
    required this.mid,
  });

  factory _Params.fromConfig(_PlayerConfig config) {
    final metaData = crypto.enc.hex
        .parse(config.cid)
        .convertToString(crypto.enc.utf8)
        .split('|');

    return _Params(
        signature: config.params.signature,
        timestamp: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60,
        route: metaData[1].replaceFirst('player.php', 'source.php'),
        ip: metaData[0],
        usesMid: config.params.usesMid,
        // userAegent: userAegent,
        mid: '${(config.params.usesMid ? "mid" : "id")}=${config.params.id}');
  }

  Future<String> getEnctrypedParams(String shortName, String key) async {
    print(toString());

    final map = {
      "USERAGENT": USERAGENT,
      "ROUTE": route,
      "MID": mid,
      "IP": ip,
      "SIG": signature,
      "TIMESTAMP": timestamp,
      "KEY": key
    };

    final order = (await client.get(
            "https://raw.githubusercontent.com/enimax-anime/gogo/main/KAA.json"))
        .json((json) => (json[shortName] as List<dynamic>)
            .mapAsList((it) => it.toString()));
    final sigArr = [];
    for (final item in order) {
      sigArr.add(map[item]);
    }
    print(sigArr.join(""));
    return SHA1(sigArr.join(",")).toString();
  }

  @override
  String toString() {
    return '_Params(signature: $signature, timestamp: $timestamp, route: $route, ip: $ip, mid: $mid)';
  }
}

class _PlayerConfig {
  final String cid;
  final _PlayerConfigParams params;

  _PlayerConfig(this.cid, this.params);

  factory _PlayerConfig.fromString(String text) {
    final regex = RegExp(r'(\w+):');
    regex.allMatches(text).forEach((element) {
      // print(element.group(0));
      text = text.replaceFirst(
        regex,
        '"${element.group(1)}":',
      );
    });
    text = text.replaceAll("'", '"');

    print(text);
    return _PlayerConfig.fromJson(jsonDecode(text));
  }

  factory _PlayerConfig.fromJson(dynamic json) {
    return _PlayerConfig(
        json['cid'], _PlayerConfigParams.fromJson(json['config_params']));
  }

//helps in debug
  @override
  String toString() {
    return '_PlayerConfig($cid, $params)';
  }
}

class _PlayerConfigParams {
  final String id;
  final String signature;
  final bool usesMid;

  _PlayerConfigParams(this.id, this.signature, this.usesMid);

  factory _PlayerConfigParams.fromJson(dynamic json) {
    return _PlayerConfigParams(
        json['id'] ?? json['mid'], json['signature'], json['mid'] != null);
  }

  @override
  String toString() {
    return '_PlayerConfigParams($id, $signature, $usesMid)';
  }
}

void main(List<String> args) async {
  // final a = KickAssExtractor(VideoServer(
  //     url:
  //         'https://vidco.pro/sapphire-duck-v2/player.php?mid=Yzg5ZTQ5Yzk0OWE1NDY3NzkwZGUyOWZjZjU0NjcxZmI6YjZiZDA3Y2FhZjM5ODBmM2IyNmI1NWJlNmZiNzllYWQ',
  //     name: '',
  //     extra: {'shortName': 'duck'}));
  // print(await a.extract());
}
