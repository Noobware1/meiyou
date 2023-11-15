// import 'package:netflix/providers/extractors/cinegrabber_extractor.dart';
// import 'package:netflix/providers/extractors/filemoon_extractor.dart';
// import 'package:netflix/helpers/data_classes.dart';

// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/providers/movie_providers/base_movie_source_parser.dart';

// class Ask4Movies extends MovieSource {
//   @override
//   String get name => 'Ask4Movies';
//   @override
//   String get hostUrl => 'https://ask4movie.mx';
//   @override
//   String get sourceType => SourceType.movieSource;

//   @override
//   // TODO: implement providerType
//   String get providerType => 'MovieSource';

//   @override
//   Future<List<SearchResponse>?> search(String query) async {
//     final response = await client.get('$hostUrl/?s=${encode(query, "+")}');
//     //print(response.text);
//     final doc = response.document;
//     final imageRegex = RegExp(r'background-image: url\((.*)\)');
//     var cover = doc.select('#search-content > div').attr('style');
//     //cover.removeLast();
//     cover = cover.map((img) {
//       final match = imageRegex.firstMatch(img);
//       return match?.group(1) ?? '';
//     }).toList();
//     ;

//     final title = doc
//         .select('#search-content > div > .main-item > div.description > p > a')
//         .text();
//     final url = doc
//         .select('#search-content > div > .main-item > div.description > p > a')
//         .attr('href');
//     final list = SearchResponse.toBuildSearchResponse(
//         title, cover, url, (url) => _typeCallback(url));

//     list.removeWhere(
//         (res) => !res.url.contains('channel') && res.url.contains('season'));
//     return list;
//   }

//   @override
//   Future<LoadResponse?> load(
//       {required SearchResponse data,
//       List<Season>? seasons,
//       Season? season}) async {
//     //print(data.title);
//     final LoadResponse? response;
//     if (data.type == MediaType.movie) {
//       final movie = await loadMovie(data.url);
//       response = (movie != null)
//           ? LoadResponse(
//               searchResponse: data, num: ['0'], urls: [movie.movieUrl])
//           : null;
//     } else if (data.type == MediaType.tvShow) {
//       final List<Episode>? episode;
//       if (seasons == null) {
//         final allSeasons = await loadSeasons(data.url);
//         if (allSeasons == null || allSeasons.isEmpty) {
//           episode = await loadEpisodes(data.url);
//           response = (episode != null)
//               ? LoadResponse.loadTvResponse(data, episode, seasons)
//               : null;
//         } else {
//           episode = await loadEpisodes(
//               allSeasons[season!.number.toInt() - 1].seasonUrl);
//           response = (episode != null)
//               ? LoadResponse.loadTvResponse(data, episode, allSeasons)
//               : null;
//         }
//       } else {
//         episode =
//             await loadEpisodes(seasons[season!.number.toInt() - 1].seasonUrl);
//         response = (episode != null)
//             ? LoadResponse.loadTvResponse(data, episode, seasons)
//             : null;
//       }
//     } else {
//       response = null;
//     }
//     return response;
//   }

//   Map<String, String> _typeCallback(String url) {
//     if (url.contains('season') || url.contains('channel')) {
//       return {'url': url, 'type': MediaType.tvShow};
//     } else {
//       return {'url': url, 'type': MediaType.movie};
//     }
//   }

//   @override
//   Future<Movie?> loadMovie(String url) async {
//     final response = (await client.get(url)).text;
//     if (response.startsWith(vaildString)) {
//       final iframe = _getIframe(response).split('/');
//       String movieUrl;
//       if (iframe.length == 6) {
//         iframe.removeLast();
//         movieUrl = iframe.join('/').replaceFirst('/v/', '/api/source/');

//         return Movie(movieUrl: movieUrl);
//       } else {
//         movieUrl = iframe.join('/').replaceFirst('/v/', '/api/source/');

//         return Movie(movieUrl: movieUrl);
//       }
//     } else {
//       return null;
//     }
//   }

//   @override
//   Future<List<Episode>?> loadEpisodes(String url) async {
//     List<String> number;
//     List<String> episodeUrl;
//     RegExpMatch? match;
//     final response = await client.get(url);
//     final text = response.text;
//     final doc = response.document;
//     if (text.startsWith(vaildString)) {
//       RegExp episodesListRegex = RegExp(r'class="group-links-list"');
//       match = episodesListRegex.firstMatch(text);
//       if (match != null) {
//         number = doc.select('ul.group-links-list > li > a').text();
//         episodeUrl =
//             doc.select('ul.group-links-list > li > a').attr('data-embed-src');
//         return Episode.toBuildEpisode(number, null, episodeUrl, null, null);
//       } else {
//         final String iframe = _getIframe(text);
//         if (iframe.isEmpty) {
//           return null;
//         } else {
//           final episodePage = (await client.get(iframe)).document;
//           final episodePageRegex = RegExp(r'https:\/\/[^\/]*');
//           match = episodePageRegex.firstMatch(iframe);
//           final mainUrl = match?.group(0) ?? '';
//           episodeUrl = episodePage
//               .select('.panel.toggleable > span')
//               .attr('data-url')
//               .map((e) => mainUrl + e.replaceFirst('/v/', '/api/source/'))
//               .toList();
//           number =
//               episodePage.select('.panel.toggleable > span').text().map((text) {
//             final regex = RegExp(r'E([0-9]+)');
//             var str = text.substring(3, text.length - 13).trim();
//             match = regex.firstMatch(str);
//             return match?.group(1) ?? '';
//           }).toList();
//           final list =
//               Episode.toBuildEpisode(number, null, episodeUrl, null, null);
//           return list;
//         }
//       }
//     } else {
//       return null;
//     }
//   }

//   @override
//   Future<List<Season>?> loadSeasons(String url) async {
//     try {
//       final response = (await client.get(url)).document;
//       var channel = response;
//       const selector = '.channels.categories.cactus-info > a';
//       if (url.contains('channel')) {
//         channel = response;
//       } else if (!url.contains('channel') && !response.isPresent(selector)) {
//         return null;
//       } else if (response.isPresent(selector)) {
//         final channelUrl = response
//             .selectFirst('.channels.categories.cactus-info > a')
//             .attr('href');
//         channel = (await client.get(channelUrl)).document;
//       }
//       final channelSelector = channel
//           .select('div.main-item > .description > p > a')
//           .reversed
//           .toList();

//       final seasons = List.generate(channelSelector.length, (i) {
//         final url = channelSelector[i].attr('href');
//         return Season(
//             number: RegExp(r'-(\d+$)').firstMatch(url)?.group(1) ??
//                 (i + 1).toString(),
//             seasonUrl: url);
//       });

//       return seasons.isNotEmpty ? seasons : null;
//       //season-(\d+)
//       // final number =
//       //     channel.select('div.main-item > .description > p > a').text();
//       // final seasonUrl =
//       //     channel.select('div.main-item > .description > p > a').attr('href');

//       // return Season.toBuildSeason(number, seasonUrl).reversed.toList();
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   @override
//   Future<List<VideoServer>> loadVideoServers(String url) {
//     return Future.value([
//       VideoServer(
//           name: Uri.parse(url).host.replaceFirst('.com', '').toUpperCaseFirst(),
//           serverUrl: url)
//     ]);
//   }

//   @override
//   VideoExtractor loadVideoExtractor(VideoServer server) {
//     if (server.serverUrl.contains('filemoon')) {
//       return FileMoonExtractor(server);
//     } else {
//       return CineGrabberExtractor(server);
//     }
//   }

//   String _getIframe(String body) {
//     final regex = RegExp(r'data-src="([^"]*)"');
//     final match = regex.firstMatch(body);
//     if (match != null) {
//       return match.group(1) ?? '';
//     } else {
//       return '';
//     }
//   }

//   @override
//   String get vaildString => '<!DOCTYPE html>';
// }
