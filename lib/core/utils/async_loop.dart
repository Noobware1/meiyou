import 'dart:async';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/utils/m3u8_parser/m3u8_parser.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

Future<void> asyncForLoop<T>(
    {required int end,
    required Future<T> Function(int index) fun,
    bool cancelOnError = false,
    void Function(Object reason)? onCancel,
    void Function(T data)? onData,
    void Function()? onDone,
    int start = 0,
    void Function(Object error, StackTrace stackTrace)? onError}) async {
  for (var i = start; i < end; i++) {
    try {
      final data = await fun.call(i);
      onData?.call(data);
    } catch (_, __) {
      if (cancelOnError) {
        onCancel?.call(_);
        break;
      } else {
        onError?.call(_, __);
      }
    }
    onDone?.call();
  }
}

class Downloader {
  Future<int> downloadHlsVideo(
    final Video video, {
    required final String savePath,
    Map<String, String>? headers,
    OKHttpRequest? options,
    void Function(double recevied, double total)? onRecevieProgress,
  }) async {
    final parser = M3u8Parser();

    final getM3u8 = (await client.options(options ??
            OKHttpRequest.builder(
              method: 'GET',
              url: video.url,
              headers: headers,
            )))
        .text;

    final segements = parser.parseM3u8FileData(video.url, getM3u8);
    final downloaded = parser.downloadMp4FromM3u8(
      savePath: savePath,
      segements: segements,
      onReceiveProgress: onRecevieProgress,
    );
    return downloaded;
  }

  downloadSubtitle(
    Subtitle subtitle, {
    required final String savePath,
    Map<String, String>? headers,
    OKHttpRequest? options,
    void Function(double recevied, double total)? onRecevieProgress,
  }) {
    return client.download(
        savePath: savePath,
        url: subtitle.url,
        headers: headers,
        onReceiveProgress: (received, total) =>
            onRecevieProgress?.call(received.toDouble(), total.toDouble()));
  }
}

// _handleOnRecevied(double a, double b) => print('donwloaded $a out of $b');

// void main(List<String> args) async {
//   final downloader = Downloader();
//   await downloader.downloadHlsVideo(
//       const Video(
//           url:
//               'https://tc-1.dayimage.net/_v6/c65e2ee56d18c7c74379664dcbe4e070aac7990a5c970029ba2274e637d0728683154f4faf83a4c44082278094bea78f1aebd07e6a5d18112bc0955088621c982c76e415e906e2b2b5187b59bfacb752ce5506dda6ec560f769edc029aff687106c2b984f0a71ff2f4ea05f8dd5f1e76fefc9f4196aa41ec8157b7ad38a4067a/index-f1-v1-a1.m3u8',
//           quality: WatchQualites.quaility1080,
//           fromat: VideoFormat.hls),
//       savePath: 'E:/Projects/meiyou/lib/core/utils/test',
//       onRecevieProgress: _handleOnRecevied);
//   // await downloader.downloadSubtitle(
//   //     const Subtitle(
//   //         url:
//   //             "https://ccb.megaresources.co/ca/96/ca9669bd3c826ff2ae7f459df73d8d32/ca9669bd3c826ff2ae7f459df73d8d32.vtt",
//   //         format: SubtitleFormat.vtt,
//   //         lang: 'ENG'),
//   //     savePath: 'E:/Projects/meiyou/lib/core/utils/lol.vtt',
//   //     onRecevieProgress: _handleOnRecevied);
// }
