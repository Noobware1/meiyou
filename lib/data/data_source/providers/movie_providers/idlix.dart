// import 'package:netflix/helpers/data_classes.dart';
// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/providers/extractors/jeniusplay_extractor.dart';
// import 'package:netflix/providers/movie_providers/base_movie_source_parser.dart';
// import 'package:netflix/providers/movie_providers/open_load_movies.dart';

// class Idlix extends MovieSource {
//   @override
//   String get name => 'Idlix';

//   @override
//   String get hostUrl => 'https://88.210.14.111';
//   final String referUrl = 'https://88.210.14.111';

//   @override
//   // TODO: implement sourceType
//   String get sourceType => SourceType.movieSource;

//   @override
//   Future<List<SearchResponse>?> search(String query) async {
//     try {
//       final json = (await client.get(
//               '$hostUrl/wp-json/dooplay/search/?keyword=${encode(query, "%20")}&nonce=f83beb327e',
//               verify: false))
//           .json() as Map<String, dynamic>?;
//       final data = json?.keys
//           .map((e) => OpenLoadMoviesResponse.fromJson(json[e]))
//           .toList();
//       print(data);
//       data?.removeWhere((response) =>
//           response.title == null &&
//           response.url == null &&
//           response.img == null);
//       if (data != null) {
//         return data.map((response) {
//           final url = response.url!;
//           return SearchResponse(
//               title: response.title!,
//               cover:
//                   'https://image.tmdb.org/t/p/original/${response.img!.toString().substringAfterLast("/")}',
//               url: url,
//               type:
//                   (url.contains('movie') ? MediaType.movie : MediaType.tvShow));
//         }).toList();
//       } else {
//         print('lol');
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
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
//       response = (movie != null)
//           ? LoadResponse(
//               searchResponse: data, num: ['0'], urls: [movie.movieUrl])
//           : null;
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
//   Future<List<Episode>?> loadEpisodes(String url) async {
//     try {
//       final page =
//           await client.get(url.substringBeforeLast('x'), verify: false);
//       if (page.isSucess == true) {
//         final doc = page.document;
//         print(doc);
//         final seasonNumber = url.substringAfterLast('x');
//         final season = doc
//             .select('#seasons > .se-c')
//             .reversed
//             .toList()[seasonNumber.toInt() - 1];

//         final number = season
//             .select('.se-a > .episodios > li > .numerando')
//             .text()
//             .map((text) => text.substringAfter('-'))
//             .toList();
//         final episodeUrl =
//             season.select('.episodios > li > .episodiotitle > a').attr('href');
//         return Episode.toBuildEpisode(number, null, episodeUrl, null, null);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   @override
//   Future<Movie?> loadMovie(String url) {
//     if (url.contains('/movie/')) {
//       return Future.value(Movie(movieUrl: url));
//     } else {
//       return Future.value(null);
//     }
//   }

//   @override
//   Future<List<Season>?> loadSeasons(String url) async {
//     try {
//       if (url.contains('/movie/')) {
//         return null;
//       } else {
//         final page = (await client.get(url, verify: false)).document;

//         final number = page
//             .select('#seasons > div.se-c > .se-q > span:first-child')
//             .text();
//         final season = number
//             .map((text) => Season(number: text, seasonUrl: '${url}x$text'))
//             .toList();
//         // print(season.map((e) => {e.number, e.seasonUrl}));
//         return season.reversed.toList();
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<List<VideoServer>?> loadVideoServers(String url) async {
//     try {
//       final page = (await client.get(url, verify: false)).document;
//       final headers = {
//         'accept': '*/*',
//         'accept-language': 'en-US,en;q=0.9',
//         'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
//         'referer': url,
//         'user-agent':
//             'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.56',
//         'x-requested-with': 'XMLHttpRequest'
//       };
//       final id =
//           page.selectFirst('meta#dooplay-ajax-counter').attr('data-postid');
//       final nume =
//           page.select('ul#playeroptionsul > li').attr('data-nume').last;
//       final type =
//           page.selectFirst('ul#playeroptionsul > li').attr('data-type');
//       final apiUrl = '$hostUrl/wp-admin/admin-ajax.php';

//       final json = (await client.post(apiUrl,
//               body: {
//                 "action": "doo_player_ajax",
//                 "post": id,
//                 "nume": nume,
//                 "type": type
//               },
//               headers: headers,
//               verify: false))
//           .json();
//       ;

//       final serverUrl = json?['embed_url'].toString();
//       if (serverUrl != null) {
//         return [
//           VideoServer(
//               name: Uri.parse(serverUrl).host.substringBefore('.'),
//               serverUrl: serverUrl)
//         ];
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   VideoExtractor loadVideoExtractor(String serverUrl) {
//     return JeniusPlay(serverUrl);
//   }
// }
