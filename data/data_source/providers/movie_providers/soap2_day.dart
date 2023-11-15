// import 'package:netflix/helpers/data_classes.dart';
// import 'package:netflix/helpers/utils.dart';
// import 'package:netflix/providers/movie_providers/base_movie_source_parser.dart';

// class Soap2Day extends MovieSource {
//   @override
//   // TODO: implement name
//   String get name => 'Soap2Day';

//   @override
//   // TODO: implement hashCode
//   String get hostUrl => 'https://secretlink.xyz/';

//   @override
//   Future<List<SearchResponse>?> search(String query) {
//     // TODO: implement search
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
//   Future<List<VideoServer>?> loadVideoServers(String url) async {
//     return [VideoServer(name: 'Main Source', serverUrl: url)];
//   }

//   @override
//   VideoExtractor loadVideoExtractor(String serverUrl) {
//     throw UnimplementedError();
//     //   try {
//     //     final page = await client.get(serverUrl);
//     //     final headers = {
//     //       "Host": "secretlink.xyz",
//     //       "User-Agent":
//     //           "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.56",
//     //       "Accept": "application/json, text/javascript, */*; q=0.01",
//     //       "Accept-Language": "en-US,en;q=0.5",
//     //       "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//     //       "X-Requested-With": "XMLHttpRequest",
//     //       "Origin": "https://secretlink.xyz",
//     //       "DNT": "1",
//     //       "Connection": "keep-alive",
//     //       "Referer": serverUrl,
//     //       "Sec-Fetch-Dest": "empty",
//     //       "Sec-Fetch-Mode": "cors",
//     //       "Sec-Fetch-Site": "same-origin",
//     //     };
//     //   } catch (e) {
//     //     return null;
//     //   }
//     // }
//   }

//   void main(List<String> args) async {
//     final headers = {
//       'Host': "secretlink.xyz",
//       'User-agent':
//           "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.56",
//       'Accept': "application/json, text/javascript, */*; q=0.01",
//       'Accept-Language': "en-US,en;q=0.9",
//       'Content-type': "application/x-www-form-urlencoded; charset=UTF-8",
//       'X-Requested-With': "XMLHttpRequest",
//       'Origin': "https://secretlink.xyz",
//       'DNT': "1",
//       'Connection': "keep-alive",
//       'Referer':
//           "https://secretlink.xyz/EczoyMzoiMTkyMjQ3fHwyMDIuMTQyLjEyMi4xNjciOw.html",
//       'Sec-Fetch-Dest': "empty",
//       'Sec-Fetch-Mode': "cors",
//       'Sec-Fetch-Site': "same-origin",
//     };

//     final la = await client.get(
//         'https://embed.smashystream.com/playere.php?imdb=tt0903747&season=1&episode=1',
//         headers: {
//           'referer': "https://smashystream.com/",
//         });

//     print(la.text);
// //  "Host" to "secretlink.xyz",
// //                     "User-Agent" to USER_AGENT,
// //                     "Accept" to "application/json, text/javascript, */*; q=0.01",
// //                     "Accept-Language" to "en-US,en;q=0.5",
// //                     "Content-Type" to ,
// //                     "X-Requested-With" to "XMLHttpRequest",
// //                     "Origin" to "https://secretlink.xyz",
// //                     "DNT" to "1",
// //
// //                     "Referer" to data,
// //                     "Sec-Fetch-Dest" to "empty",
// //                     "Sec-Fetch-Mode" to "cors",
// //                     "Sec-Fetch-Site" to "same-origin",
//     //'cookie': "cf_clearance=xA2.EcmslR33rHcCMqNLdG78fSbDwb_oo9iesoFucYc-1677501940-0-160",

//     final a =
//         await client.post('https://secretlink.xyz/home/index/GetEInfoAjax',
//             body: {
//               'pass': 'aToxOTIyNDc7',
//               'param': 'https%3A%2F%2Ff8.s2dstore.to',
//             },
//             headers: headers);

//     // print(a.data);
//   }
// }
