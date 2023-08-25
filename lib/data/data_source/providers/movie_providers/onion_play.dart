// import 'dart:convert';

// import 'package:streamify/helpers/data_classes.dart';
// import 'package:streamify/helpers/utils.dart';
// import 'package:streamify/providers/extractors/base_video_extractor.dart';

// import '../../helpers/js_unpacker.dart';

// class OnionPlayExtractor extends VideoExtractor {
//   OnionPlayExtractor(super.server);

//   @override
//   String get name => 'Juicy';

//   @override
//   String get hostUrl => server.serverUrl;

//   @override
//   Future<VideoFile?> extractor([String referer = '']) async {
//     final res = await client.get(hostUrl);
//     final juicyCode =
//         RegExp(r'JuicyCodes\.Run(.*)\);').firstMatch(res.text)!.group(1)!;
//     final decoded = juicyCodeDecoded(juicyCode);
//     if (decoded == null) return null;
//     var jsonString =
//         '{${RegExp(r'file:\[\{(.*)\}\]').firstMatch(decoded)!.group(0)!}}';
//     final file = json.decode(jsonString)['file'];

//     return VideoFile(source: name, data: [
//       VideoFileUrlAndQuailty(WatchQualites.quaility720, file,
//           VideoFileUrlAndQuailty.getTypeFromString(file))
//     ]);
//   }

//   static const juice =
//       "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

//   String? juicyCodeDecoded(String e) {
//     String t = "";
//     int n, r, i, s, o, u, a, f = 0;
//     e = e.replaceAll(RegExp(r"[^A-Za-z0-9+\=\/]"), "");
//     while (f < e.length) {
//       s = juice.indexOf(e[f++]);
//       o = juice.indexOf(e[f++]);
//       u = juice.indexOf(e[f++]);
//       a = juice.indexOf(e[f++]);
//       n = (s << 2) | (o >> 4);
//       r = ((15 & o) << 4) | (u >> 2);
//       i = ((3 & u) << 6) | a;
//       t += String.fromCharCode(n);
//       if (u != 64) {
//         t += String.fromCharCode(r);
//       }
//       if (a != 64) {
//         t += String.fromCharCode(i);
//       }
//     }
//     return JSPacker(t).unpack();
//   }
// }

