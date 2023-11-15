// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:meiyou/core/client.dart';
// import 'package:ok_http_dart/ok_http_dart.dart';

// class Downloader {
//   final String savePath;
//   // final void Function(int, int)? onReceiveProgress;
//   final bool deleteOnError;
//   final OKHttpRequest request;
//   final Duration? timeout;
//   final controller = StreamController<DownloadProgress>();
//   late final file = File(savePath);
//   Downloader({
//     required this.savePath,
//     // this.onReceiveProgress,
//     this.deleteOnError = true,
//     this.timeout,
//     required this.request,
//   });

//   pause() {}

//   retry() {}

//   cancel() {}

//   download() async {
//     try {
//       final response = await client.createClient().send(request);

//       file.createSync(recursive: true);

//       RandomAccessFile raf = file.openSync(mode: FileMode.write);

//       final completer = Completer<OkHttpResponse>();
//       var bytesCompleter = Completer<Uint8List>();

//       var sink = ByteConversionSink.withCallback(
//           (bytes) => bytesCompleter.complete(Uint8List.fromList(bytes)));

//       int received = 0;

//       final stream = response.stream;

//       final total =
//           double.tryParse(response.headers['content-length'].toString()) ??
//               -1.0;

//       final startByte = total > 30 * 10000 ? total / 2 : 0;

//       // .sink.add(DownloadProgress(
//       //     status: DownloadStatus.downloading, downloaded: 0.0, total: total));

//       // Future<void>? asyncWrite;
//       // bool closed = false;
//       // Future<void> closeAndDelete() async {
//       //   if (!closed) {
//       //     closed = true;
//       //     await asyncWrite;
//       //     await raf.close();
//       //     if (deleteOnError && file.existsSync()) {
//       //       await file.delete();
//       //     }
//       //   }
//       // }

//       late StreamSubscription subscription;
//       // // final Stopwatch watch = Stopwatch()..start();

//       subscription = stream.listen((data) {
//         sink.add(data);

//         subscription.pause();
//         // Write file asynchronously
//         // asyncWrite = raf.writeFrom(data).then((result) {
//           // Notify progress
//           received += data.length;
//           controller.sink.add(DownloadProgress(
//               status: DownloadStatus.downloading,
//               downloaded: received.toDouble(),
//               total: total));

//           raf = result;
//           subscription.resume();
//         }).catchError((Object e) async {
//           try {
//             await subscription.cancel();
//           } finally {
//             // completer.completeError(
//             //   http.ClientException(e.toString(), req.url),
//             // );
//           }
//         });
//       });
//     } catch (_) {
//       throw Error();
//     }
//   }
// }

// class DownloadProgress {
//   final DownloadStatus status;
//   final double downloaded;
//   final double total;

//   DownloadProgress(
//       {required this.status, required this.downloaded, required this.total});
// }

// enum DownloadStatus {
//   downloading,
//   paused,
//   retrying,
//   cancelled,
// }
