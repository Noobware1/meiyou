// import 'dart:convert';
// import 'package:ok_http_dart/ok_http_dart.dart';
// import 'package:streamify/helpers/data_classes.dart';
// import 'package:streamify/helpers/utils.dart';
// import 'package:streamify/providers/extractors/vidmoly_extractor.dart';
// import 'package:streamify/providers/movie_providers/base_movie_source_parser.dart';
// import 'package:html/parser.dart' as html;

// class DreamFlim extends MovieSource {
//   @override
//   String get name => 'DreamFlim';

//   @override
//   String get hostUrl => 'https://dreamfilmsw.net';

//   @override
//   Future<LoadResponse?> load(
//       {required SearchResponse data, List<Season>? seasons, Season? season}) {
//     // TODO: implement load
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Episode>?> loadEpisodes(String url) async {
//     final json = jsonDecode(url);
//     final doc = html.parse(json['doc'].toString());
//     final episodes = doc
//         .select(
//             'div.seasonsTabs-tabContent > div#$url > .card-list.horizontal.row > div')
//         .map((it) {
//       final a = it.selectFirst('a');
//       return Episode(
//           number: RegExp(r'Säsong\s(\d+).')
//               .firstMatch(a.selectFirst('div > h3').text)!
//               .group(1)!,
//           url: a.attr('href'));
//     }).toList();
//     return episodes;
//   }

//   @override
//   Future<Movie?> loadMovie(String url) {
//     return Future.value(Movie(url: url));
//   }

//   @override
//   Future<List<Season>?> loadSeasons(String url) async {
//     final res = await client.get(url);
//     final seasons =
//         res.document.select('nav.card-nav.horizontal.nav-slider > a').map((it) {
//       return Season(
//           number: RegExp(r'Säsong\s(\d+)').firstMatch(it.text)!.group(1)!,
//           seasonUrl: jsonEncode({
//             'doc': res.text,
//             'season': it.attr('href').substringAfter('#')
//           }));
//     }).toList();

//     return seasons;
//   }

//   @override
//   VideoExtractor? loadVideoExtractor(VideoServer server) {
//     return VidmolyExtractor(server);
//   }

//   @override
//   Future<List<VideoServer>?> loadVideoServers(String url) async {
//     final res = await client.get(url);
//   }

//   @override
//   Future<List<SearchResponse>?> search(String query) async {
//     final json = (await client.post('$hostUrl/search', headers: {
//       "User-Agent":
//           "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0",
//       "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//       "X-Requested-With": "XMLHttpRequest"
//     }, body: {
//       "query": encode(query, '+')
//     }))
//         .json();

//     final results = List.from(json['result']);

//     if (results.isEmpty) {
//       return null;
//     }
//     return results.map((data) {
//       final type =
//           data['slug_prefix'] == 'series/' ? MediaType.tvShow : MediaType.movie;
//       final slug = data['slug'];
//       return SearchResponse(
//           title:
//               data['title'] ?? data['second_title'] ?? data['original_title'],
//           cover: '$hostUrl/uploads/poster/${data["poster"]}',
//           url: type == MediaType.tvShow
//               ? '$hostUrl/series/$slug'
//               : '$hostUrl/$slug',
//           type: type);
//     }).toList();
//   }
// }
