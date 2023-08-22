// import 'package:html/dom.dart';
// import 'package:netflix/helpers/ok_http.dart';

// import 'package:netflix/providers/movie_providers/base_movie_source_parser.dart';
// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/helpers/data_classes.dart';
// import 'package:netflix/providers/extractors/hdmovie_box_extractor.dart';

// import '../extractors/vidmoly_extractor.dart';

// class HDMovieBox extends MovieSource {
//   @override
//   String get name => 'HDMovieBox';
//   @override
//   String get hostUrl => 'https://hdmoviebox.net';

//   @override
//   String get sourceType => SourceType.movieSource;

//   @override
//   Future<List<SearchResponse>?> search(String query) async {
//     final response = (await client.post(
//             'https://hdmoviebox.net/search?qr=${encode(query, "%20")}',
//             headers: {
//           'referer': hostUrl,
//           'x-requested-with': 'XMLHttpRequest'
//         }))
//         .json();

//     if (response == null || response['error'] != null) {
//       print('a');
//       return null;
//     } else {
//       final json = HDMovieApiSearchResponse.fromJson(response!);
//       final data = json.result.map((data) {
//         final String title = data['s_customname'] ?? data['s_name'] ?? "";
//         final String cover = data['s_cover'] ?? data['s_image'] ?? "";
//         final String url = data['s_link'] ?? "";
//         final String type =
//             (data['s_type'] == '1') ? MediaType.movie : MediaType.tvShow;
//         if (title.isNotEmpty && cover.isNotEmpty && url.isNotEmpty) {
//           return SearchResponse(
//               title: title,
//               cover: '$hostUrl/uploads/series/$cover',
//               url: '$hostUrl/watch/$url',
//               type: type);
//         } else {
//           return SearchResponse(title: '', cover: '', url: '', type: '');
//         }
//       }).toList();
//       data.removeWhere((item) =>
//           item.cover.isEmpty &&
//           item.title.isEmpty &&
//           item.url.isEmpty &&
//           item.type.isEmpty);

//       return data;
//     }
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
//       response = LoadResponse(
//           searchResponse: data, num: ['0'], urls: [movie.movieUrl]);
//     } else if (data.type == MediaType.tvShow) {
//       if (seasons == null) {
//         final allSeasons = await loadSeasons(data.url);
//         if (allSeasons == null || allSeasons.isEmpty) {
//           return null;
//         }
//         final tv = await loadEpisodes(
//             allSeasons[season!.number.toInt() - 1].seasonUrl);
//       }

//       final tv =
//           await loadEpisodes(seasons![season!.number.toInt() - 1].seasonUrl);

//       response =
//           (tv != null) ? LoadResponse.loadTvResponse(data, tv, seasons) : null;
//     } else {
//       response = null;
//     }
//     return response;
//   }

//   @override
//   Future<List<Episode>?> loadEpisodes(String url, [int? season]) async {
//     try {
//       final document = (await client.get(url)).document;
//       String episodeListSelector;
//       if (season != null) {
//         episodeListSelector =
//             'div.sixteen.wide.tablet.thirteen.wide.stretched.computer.column.season-list-column > div[data-season="$season"]';
//       } else {
//         episodeListSelector =
//             'div.sixteen.wide.tablet.thirteen.wide.stretched.computer.column.season-list-column > div:first-child';
//       }
//       const tableSelector =
//           ' > .tabular-content > .episodes-list > .ui.list > div > .ui.basic.unstackable.table > tbody > tr > td';
//       final episodeUrl = document
//           .select('$episodeListSelector$tableSelector > .ordilabel > a')
//           .attr('href')
//           .map((url) => '$hostUrl$url')
//           .toList();

//       final number = document
//           .select('$episodeListSelector$tableSelector > .ordilabel > a')
//           .text()
//           .map((ep) => ep.replaceFirst('Episode ', '').trim())
//           .toList();

//       final episodeName = document
//           .select(
//               '$episodeListSelector$tableSelector#table-episodes-title > .truncate > a')
//           .text();
//       return Episode.toBuildEpisode(
//           number, episodeName, episodeUrl, null, null);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   @override
//   Future<Movie> loadMovie(String url) async {
//     final page = (await client.get(url)).document;

//     final movieUrl = await _buildAPIUrl(page);

//     return (movieUrl != null)
//         ? Movie(movieUrl: movieUrl)
//         : Movie(movieUrl: url);
//   }

//   @override
//   Future<List<Season>?> loadSeasons(String url) async {
//     final document = (await client.get(url)).document;
//     const selector = '#seasons-menu > div > a';
//     if (!document.isPresent(selector)) {
//       return null;
//     } else {
//       final number = document.select(selector).attr('data-season');
//       final seasonUrl = document
//           .select('#seasons-menu > div > a')
//           .attr('href')
//           .map((url) => '$hostUrl$url')
//           .toList();
//       ;
//       return Season.toBuildSeason(number, seasonUrl);
//     }
//   }

//   Future<String?> _buildAPIUrl(Document document) async {
//     final id = document.selectFirst('div#not-loaded').attr('data-whatwehave');
//     const apiUrl = 'https://hdmoviebox.net/ajax/service';
//     final json = await client.post(apiUrl, body: {
//       'e_id': id,
//       'v_lang': 'en',
//       'type': 'get_whatwehave'
//     }, headers: {
//       'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
//       'x-requested-with': 'XMLHttpRequest'
//     });

//     RegExp jsonMatchRegex = RegExp(r'("api_iframe")');

//     if (jsonMatchRegex.hasMatch(json.text)) {
//       final jsonParsed = json.json();
//       final apiIframe = jsonParsed?['api_iframe'] ?? '';
//       await Future.delayed(const Duration(milliseconds: 1000));

//       final page =
//           (await client.get(apiIframe, headers: {'referer': '$hostUrl/'}))
//               .document;

//       final iframe = page.selectFirst('iframe').attr('src');
//       return httpifyUrl(iframe);
//     } else {
//       return null;
//     }
//   }

//   @override
//   Future<List<VideoServer>> loadVideoServers(String url) async {
//     return [VideoServer(name: 'HDFreeStream', serverUrl: url)];
//   }

//   @override
//   VideoExtractor loadVideoExtractor(String serverUrl) {
//     if (serverUrl.contains('vid')) {
//       return VidmolyExtractor(serverUrl);
//     }
//     return HDMovieExtractor(serverUrl);
//   }

//   @override
//   String get vaildString => '<!DOCTYPE HTML>';
// }

// class HDMovieApiSearchResponse {
//   List<dynamic> result;

//   HDMovieApiSearchResponse({required this.result});

//   factory HDMovieApiSearchResponse.fromJson(Map<String, dynamic> json) {
//     return HDMovieApiSearchResponse(result: json['data']['result']);
//   }
// }
