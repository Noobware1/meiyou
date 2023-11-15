// import 'dart:convert';

// import 'package:netflix/helpers/data_classes.dart';
// import 'package:netflix/helpers/m3u8_helper.dart';
// import 'package:netflix/helpers/subtitle_helper.dart';
// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/providers/movie_providers/base_movie_source_parser.dart';

// class StreamLord extends MovieSource {
//   @override
//   Future<List<SearchResponse>?> search(String query) {
//     // TODO: implement search
//     throw UnimplementedError();
//   }

//   @override
//   Future<LoadResponse?> load(
//       {required SearchResponse data, List<Season>? seasons, Season? season}) {
//     // TODO: implement load
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Episode>?> loadEpisodes(String url) {
//     // TODO: implement loadEpisodes
//     throw UnimplementedError();
//   }

//   @override
//   Future<Movie?> loadMovie(String url) {
//     // TODO: implement loadMovie
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Season>?> loadSeasons(String url) {
//     // TODO: implement loadSeasons
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<VideoServer>?> loadVideoServers(String url) {
//     // TODO: implement loadVideoServers
//     throw UnimplementedError();
//   }

//   @override
//   VideoExtractor loadVideoExtractor(String serverUrl) {
//     // TODO: implement loadVideoExtractor
//     throw UnimplementedError();
//   }
// }

// void main(List<String> args) async {
// //  final a = await StreamLordExtractor('').extractor();
//   final a =
//       await client.post('http://www.streamlord.com/searchtest.php', headers: {
//     'User-Agent':
//         "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0",
//     'Accept':
//         "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
//     'Accept-Language': "en-US,en;q=0.5",
//     'Accept-Encoding': "gzip, deflate",
//     'Content-Type': "application/x-www-form-urlencoded",
//     'Origin': "http://www.streamlord.com",
//     'Connection': "keep-alive",
//     'Referer': "http://www.streamlord.com/",
//     'Upgrade-Insecure-Requests': "1"
//   }, body: {
//     "searchapi2": "wednesday"
//   });

//   print(a.text);
// }

// // class StreamLordExtractor extends VideoExtractor {
// //   @override
// //   // TODO: implement name
// //   String get name => 'StreamLordExtractor';
//   // @override
// //   // TODO: implement hostUrl
// //   String get hostUrl => '';

// //   StreamLordExtractor(super.serverUrl);

// //   @override
// //   Future<VideoFile?> extractor([String referer = '']) async {
// //     try {
// //       final doc = (await client.get(serverUrl)).text;

// //       final tracksJson =
// //           RegExp(r'tracks:\s(.*}])').firstMatch(doc)?.group(1)?.trimLeft();
// //       final tracks = (tracksJson != null)
// //           ? List<dynamic>.from(jsonDecode(tracksJson))
// //               .map((data) => StreamLordTracks.fromJson(data).toSubtitle())
// //               .toList()
// //           : null;

// //       final file = RegExp(r'=\s"(https:\/\/.*)";').firstMatch(doc)?.group(1);
// //       if (file == null) {
// //         return null;
// //       }

// //       final data = (await client.get(file)).text;

// //       return toM3U8Helper(source: 'StreamLord', data: data, subtitle: tracks);
// //     } catch (e) {
// //       print(e);
// //       return null;
// //     }
// //   }
// // }

// // class StreamLordTracks {
// //   final String file;
// //   final String label;

// //   const StreamLordTracks(this.file, this.label);

// //   factory StreamLordTracks.fromJson(dynamic json) {
// //     return StreamLordTracks(json['file'], json['label']);
// //   }

// //   SubtitleFile toSubtitle() {
// //     return SubtitleFile(file, label);
// //   }
// // }
