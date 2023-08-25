import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/tmdb_provider.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class SmashyStream extends TMDBProvider {
  @override
  String get hostUrl => 'https://embed.smashystream.com';

  @override
  Future<List<Episode>> loadEpisodes(
      int id, Season season, List<Episode> episodes) {
    return Future.value(episodes
        .map((it) => it.copyWith(
            url:
                '$hostUrl/playere.php?tmdb=$id&season=${season.number}&episode=${it.number}'))
        .toList());
  }

  @override
  Future<Movie> loadMovie(String id) {
    return Future.value(Movie(url: '$hostUrl/playere.php?tmdb=$id'));
  }

  @override
  Future<List<Season>> loadSeasons(List<Season>? seasons) {
    if (seasons == null) {
      throw Exception(
          'Seasons is null, either the mediaType is incorrect or there is no seasons in media');
    }
    return Future.value(seasons);
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    // TODO: implement loadVideoExtractor
    throw UnimplementedError();
  }

  @override
  Future<List<VideoServer>> loadVideoServer(String url) {
    return client.get(url).then((response) => response.document
        .select('div.dropdown-menu > a')
        .sublist(1)
        .map((it) => VideoServer(name: it.text, url: it.attr('data-id')))
        .toList());
  }

  @override
  String get name => 'SmashyStream';
}

void main(List<String> args) async {
  final a = await SmashyStream().loadVideoServer(
      'https://embed.smashystream.com/playere.php?tmdb=1396&season=1&episode=1');
  a.forEach((it) => print({it.name, it.url}));
}
