import 'dart:convert';
import 'package:bridge_lib/bridge_lib.dart';

class GogoCDN extends ExtractorApi {
  GogoCDN(ExtractorLink extractorLink) : super(extractorLink);

  @override
  Future<MediaEntity> extract() async {
    final doc = (await MeiyouUtils.httpRequest(
            url: this.extractorLink.url, method: 'GET'))
        .document;

    final script =
        doc.selectFirst('script[data-name="episode"]').attr('data-value');
    final id = doc.selectFirst('#id').attr('value');

    final host = MeiyouUtils.getHost(this.extractorLink.url);

    final encryptedID = cryptoHandler(keysAndIV.key, keysAndIV.iv, id, true);

    final decryptedID =
        cryptoHandler(keysAndIV.key, keysAndIV.iv, script, false)
            .replaceFirst(id, encryptedID);

    final encryptedData = json.decode((await MeiyouUtils.httpRequest(
            url: 'https://$host/encrypt-ajax.php?id=$decryptedID&alias=$id',
            method: 'GET',
            headers: {'x-requested-with': 'XMLHttpRequest'}))
        .text)['data'] as String;

    final decrypted = json.decode(cryptoHandler(
        keysAndIV.secondKey, keysAndIV.iv, encryptedData, false)) as Map;

    final List<VideoSource> list = [];
    for (var e in decrypted['source'] as List) {
      list.add(toVideoSource(e, false));
    }

    if (decrypted['source_bk'] != null) {
      for (var e in decrypted['source_bk'] as List) {
        list.add(toVideoSource(e, false));
      }
    }

    return Video(videoSources: list, headers: {'referer': 'https://$host'});
  }

  VideoSource toVideoSource(Map j, bool backup) {
    final label = j['label'];
    final url = j['file'];
    if (MeiyouUtils.evalOrStatements([label != "hls P", label != "auto P"])) {
      return VideoSource(
        url: url,
        quality: VideoQuality.getFromString(label),
        format: VideoFormat.other,
        isBackup: backup,
      );
    } else {
      return VideoSource(
        url: url,
        format: VideoFormat.hls,
        isBackup: backup,
      );
    }
  }

  static const keysAndIV = Keys('37911490979715163134003223491201',
      '54674138327930866480207815084989', '3134003223491201');

  String cryptoHandler(String key, String iv, String text, bool encrypt) {
    if (encrypt) {
      return CryptoUtils.cryptoJsAes(
          ciphertext: text,
          key: key,
          iv: iv,
          encrypt: encrypt,
          options: CryptoOptions(
            ivEncoding: 'utf8',
            keyEncoding: 'utf8',
            textEncoding: 'utf8',
            encoding: 'base64',
          ));
    } else {
      return CryptoUtils.cryptoJsAes(
          ciphertext: text,
          key: key,
          iv: iv,
          encrypt: encrypt,
          options: CryptoOptions(
            ivEncoding: 'utf8',
            keyEncoding: 'utf8',
            textEncoding: 'base64',
          ));
    }
  }
}

class Keys {
  final String key;
  final String secondKey;
  final String iv;

  const Keys(this.key, this.secondKey, this.iv);
}
