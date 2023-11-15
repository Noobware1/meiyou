import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/tmdb_provider.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/data_source/providers/tmdb_providers/extractors/smashy_stream.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class SmashyStream extends TMDBProvider {
  @override
  String get hostUrl => 'https://embed.smashystream.com';

  @override
  Future<List<Episode>> loadEpisodes(Season season) async {
    return List.generate(
        season.totalEpisode!,
        (index) => Episode(
            number: index + 1, url: '${season.url!}&episode=${index + 1}'));
    // '$hostUrl/playere.php?tmdb=$id&season=${season.number}&episode=${it.number}'
  }

  @override
  Future<Movie> loadMovie(String id) {
    return Future.value(Movie(url: '$hostUrl/playere.php?tmdb=$id'));
  }

  @override
  Future<List<Season>> loadSeasons(String id, List<Season> seasons) async {
    return seasons.mapAsList((it) =>
        it.copyWith(url: '$hostUrl/playere.php?tmdb=$id&season=${it.number}'));
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return SmashyStreamExtractor(videoServer);
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) {
    return client.get(url).then((response) => response.document
        .select('div.dropdown-menu > a')
        .sublist(1)
        .map((it) =>
            VideoServer(name: it.text, url: it.attr('data-id'), referer: url))
        .toList());
  }

  @override
  String get name => 'SmashyStream';
}
