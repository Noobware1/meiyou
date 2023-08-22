// import 'package:netflix/helpers/ok_http.dart';
// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/providers/movie_providers/base_movie_source_parser.dart';
// import 'package:netflix/helpers/data_classes.dart';
// import 'package:netflix/providers/extractors/open_load_movies_extractor.dart';

// class OpenLoadMovies extends MovieSource {
//   @override
//   String get name => 'OpenLoadMovies';

//   @override
//   String get hostUrl => 'https://openloadmov.com';

//   @override
//   Future<List<SearchResponse>?> search(String query) async {
//     try {
//       final json = (await client.get(
//               'https://openloadmov.com/wp-json/dooplay/search/?keyword=${encode(query, "%20")}&nonce=f892fc2f66'))
//           .json();
//       print(json);
//       final data = json?.keys
//           .map((e) => OpenLoadMoviesResponse.fromJson(json[e]))
//           .toList();
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
//                   'https://image.tmdb.org/t/p/original/${response.img!.substringAfterLast("/")}',
//               url: url,
//               type: (url.contains('movies')
//                   ? MediaType.movie
//                   : MediaType.tvShow));
//         }).toList();
//       } else {
//         return null;
//       }
//     } catch (e) {
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
//   Future<Movie?> loadMovie(String url) {
//     if (url.contains('movies')) {
//       return Future.value(Movie(movieUrl: url));
//     } else {
//       return Future.value(null);
//     }
//   }

//   @override
//   Future<List<Episode>?> loadEpisodes(String url) async {
//     try {
//       final page = await client.get(url);
//       if (page.isSucess == true) {
//         final doc = page.document;
//         final number = doc
//             .select('.episodios > li > .numerando')
//             .text()
//             .map((text) => text.substringAfter('-'))
//             .toList();
//         final episodeUrl =
//             doc.select('.episodios > li > .episodiotitle > a').attr('href');
//         return Episode.toBuildEpisode(number, null, episodeUrl, null, null);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<List<Season>?> loadSeasons(String url) async {
//     try {
//       if (url.contains('movies')) {
//         return null;
//       } else {
//         final page = (await client.get(url)).document;
//         final number = page
//             .select('#seasons > div.se-c > .se-q > span:first-child')
//             .text();
//         final season = number
//             .map((text) => Season(
//                 number: text,
//                 seasonUrl:
//                     '${url.substringBeforeLast("/").replaceFirst("tvseries", "episodes")}-${text}x1'))
//             .toList();
//         return season;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<List<VideoServer>?> loadVideoServers(String url) async {
//     try {
//       final videoPage = await client.get(url);
//       if (videoPage.isSucess) {
//         final doc = videoPage.document;
//         final serverUrl = doc.select('div.pframe > iframe').attr('src');
//         final name = doc.select('#playeroptionsul > li > .title').text();

//         return VideoServer.toBuildVideoServer(name, serverUrl);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   VideoExtractor loadVideoExtractor(String serverUrl) {
//     return OpenLoadMoviesExtractor(serverUrl);
//   }
// }

// class OpenLoadMoviesResponse {
//   final String? title;
//   final String? url;
//   final String? img;

//   OpenLoadMoviesResponse(
//       {required this.title, required this.url, required this.img});

//   factory OpenLoadMoviesResponse.fromJson(Map<String, dynamic> json) {
//     return OpenLoadMoviesResponse(
//         title: json['title'], url: json['url'], img: json['img']);
//   }
// }
