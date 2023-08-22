import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';

class TwoNowTv extends MovieProvider {
  @override
  // TODO: implement hostUrl
  String get hostUrl => throw UnimplementedError();

  @override
  Future<List<Episode>> loadEpisodes(String url) {
    // TODO: implement loadEpisodes
    throw UnimplementedError();
  }

  @override
  Future<Movie> loadMovie(String url) {
    // TODO: implement loadMovie
    throw UnimplementedError();
  }

  @override
  Future<List<Season>> loadSeasons(String url) {
    // TODO: implement loadSeasons
    throw UnimplementedError();
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    // TODO: implement loadVideoExtractor
    throw UnimplementedError();
  }

  @override
  Future<List<VideoServer>> loadVideoServer(String url) {
    return Future.value([VideoServer(url: url, name: name)]);
  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  Future<List<SearchResponse>> search(String query) {
    // TODO: implement search
    throw UnimplementedError();
  }
}
