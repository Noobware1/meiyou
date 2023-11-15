// import 'package:myapp/api/data_classes.dart';
// import 'package:myapp/api/movie_providers/base_movie_source_parser.dart';

// class UniqueStream extends MovieSource {
//   @override
//   String get name => 'UniqueStream';

//   @override
//   String get hostUrl => 'https://uniquestreaming.net';

//   Future<List<SearchResponse>> search(String query) async{}
//   Future<Movie> loadMovie(String url);
//   Future<List<Episode>> loadEpisodes(String url, {int? season}) async {
//     final doc = await client.get(url);
//     try{

//     if(doc.data.startsWith(vaildString)) {
//       return [Episode(number: '', episodeUrl: '')]
//     }
//     }catch(e) {
//       print(e);
//       return [Episode(number: '', episodeUrl: '')];
//     }
//   };
//   Future<List<Season>> loadSeasons(String url);
//   Future<List<VideoServer>> loadVideoServers(String url);


// @override
//   String get vaildString => '<!DOCTYPE html>';

// }
