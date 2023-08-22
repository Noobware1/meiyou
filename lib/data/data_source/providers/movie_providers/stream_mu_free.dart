import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/utils.dart';
import 'package:streamify/providers/movie_providers/base_movie_source_parser.dart';

class StreamMuFree extends MovieSource {
  @override
  // TODO: implement name
  String get name => 'StreamMUFree';
  @override
  // TODO: implement hostUrl
  String get hostUrl => 'https://ww2.m4ufree.com';

  
  @override
  Future<List<SearchResponse>?> search(String query) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<LoadResponse?> load({required SearchResponse data, List<Season>? seasons, Season? season}) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<List<Episode>?> loadEpisodes(String url) {
    // TODO: implement loadEpisodes
    throw UnimplementedError();
  }

  @override
  Future<Movie?> loadMovie(String url) {
    // TODO: implement loadMovie
    throw UnimplementedError();
  }

  @override
  Future<List<Season>?> loadSeasons(String url) {
    // TODO: implement loadSeasons
    throw UnimplementedError();
  }

  @override
  Future<List<VideoServer>?> loadVideoServers(String url) {
    // TODO: implement loadVideoServers
    throw UnimplementedError();
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer server) {
    // TODO: implement loadVideoExtractor
    throw UnimplementedError();
  }
}
