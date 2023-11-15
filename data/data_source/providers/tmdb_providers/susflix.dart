import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/tmdb_provider.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/data_source/providers/tmdb_providers/extractors/susflix.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';

class Susflix extends TMDBProvider {
  @override
  String get name => 'Susflix';

  @override
  String get hostUrl => "https://susflix.tv/api";

  @override
  Future<List<Episode>> loadEpisodes(Season season) async {
    return List.generate(
        season.totalEpisode!,
        (index) => Episode(
              number: index + 1,
              url:
                  "$hostUrl/tv?id=${season.url}&s=${season.number}&e=${index + 1}",
            ));
  }

  @override
  Future<Movie> loadMovie(String id) async {
    return Movie(url: "$hostUrl/movie?id=$id");
  }

  @override
  Future<List<Season>> loadSeasons(String id, List<Season> seasons) async {
    return seasons.mapAsList((it) => it.copyWith(url: id.toString()));
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return SusflixExtractor(videoServer);
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    return [VideoServer(url: url, name: 'Susflix')];
  }
}

