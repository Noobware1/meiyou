// import 'package:netflix/helpers/data_classes.dart';
// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/providers/anime_providers/base_anime_source.dart';


// To Do
// class Crunchyroll extends AnimeSource {
//   @override
//   String get name => 'Crunchyroll';

//   @override
//   String get hostUrl => 'https://api.consumet.org/anime/crunchyroll';

//   @override
//   Future<List<SearchResponse>?> search(String query, [int number = 1]) async {
//     try {
//       final response = (await client.get('$hostUrl/$query?page=$number'));

//     } catch (e) {
//       return null;
//     }
//   }
// }
