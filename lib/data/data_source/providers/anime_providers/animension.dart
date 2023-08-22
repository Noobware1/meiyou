// import 'dart:convert';

// import 'package:meiyou/core/resources/providers/anime_provider.dart';

// class Animension extends AnimeProvider {
//   @override
//   String get name => 'Animension';

//   @override
//   // TODO: implement hostUrl
//   String get hostUrl => 'https://animension.to';

//   @override
//   Future<List<SearchResponse>?> search(String query) async {
//     try {
//       final search = (await client.get(
//               'https://animension.to/public-api/search.php?search_text=${encode(query, "%20")}&season=&genres=&dub=&airing=&sort=popular-week&page=1'))
//           .text;

//       final parsed = search
//           .substring(2, search.length - 2)
//           .split('],[')
//           .map((s) => s.split(',').map((e) => e.trim()).toList())
//           .toList();

//       final fixedRegex = RegExp(r'["\\]');

//       return List.generate(
//           parsed.length,
//           (i) => SearchResponse(
//               title: parsed[i][0].replaceAll(fixedRegex, ""),
//               cover: parsed[i][2].replaceAll(fixedRegex, ""),
//               url: '$hostUrl/${parsed[i][1]}',
//               type: MediaType.anime));
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<LoadResponse?> load(
//       {required SearchResponse data,
//       List<Season>? seasons,
//       Season? season}) async {
//     List<Episode>? episodes = await loadEpisodes(data.url);

//     return (episodes != null)
//         ? LoadResponse.fromTvResponse(episodes: episodes)
//         : null;
//   }

//   @override
//   Future<List<Episode>?> loadEpisodes(String url) async {
//     try {
//       final episodes = (await client.get(
//               'https://animension.to/public-api/episodes.php?id=${url.substringAfterLast("/")}'))
//           .text;

//       // print(episodes);

//       final List<List<String>> list = episodes
//           .substring(2, episodes.length - 2)
//           .split('],[')
//           .map((s) => s.split(',').map((e) => e.trim()).toList())
//           .toList();

//       final number = list.map((e) => e[2].toString()).toList();
//       final urls = list
//           .map((e) =>
//               'https://animension.to/public-api/episode.php?id=${e[1].toString()}')
//           .toList();

//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   VideoExtractor? loadVideoExtractor(VideoServer server) {
//     final serverUrl = server.serverUrl;
//     if (serverUrl.contains('streaming.php')) {
//       return GogoExtractor(server);
//     } else if (serverUrl.contains('sb')) {
//       return StreamSBExtractor(server);
//     } else if (serverUrl.contains('dood')) {
//       return DoodExtractor(server);
//     } else if (serverUrl.contains('video-content')) {
//       return VidCdnExtractor(server);
//     } else {
//       return null;
//     }
//   }

//   @override
//   Future<List<VideoServer>?> loadVideoServers(String url) async {
//     try {
//       final text = (await client.get(url)).text;
//       final jsonString =
//           '{${text.substring(1, text.length - 2).split('{')[2].substringBeforeLast('}').replaceAll('\\', "")}}';

//       final json = jsonDecode(jsonString) as Map<String, dynamic>;

//       final servers = VideoServer.toBuildVideoServer(json.keys.toList(),
//           json.values.map((e) => httpifyUrl(e.toString())).toList());
//       return servers;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }

// class VidCdnExtractor extends VideoExtractor {
//   @override
//   // TODO: implement name
//   String get name => 'VidCDN';

//   @override
//   // TODO: implement hostUrl
//   String get hostUrl => '';

//   VidCdnExtractor(super.serverUrl);

//   @override
//   Future<VideoFile?> extractor([String referer = '']) async {
//     try {
//       final file = server.serverUrl.substringBefore('.php');
//       // final mainUrl = file.substringBeforeLast('/');
//       // final data = (await client.get(file)).text;

//       return toM3u8Helper(
//         name,
//         file,
//       );
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }
