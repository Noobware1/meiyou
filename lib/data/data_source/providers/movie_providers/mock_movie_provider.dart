import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/extractors/rapid_cloud.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/extractors/vidcloud.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

import 'package:meiyou/data/models/video_server.dart';

class MockVideoExtractor extends VideoExtractor {
  MockVideoExtractor(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    return VideoContainer(videos: [
      Video(
          url: '', quality: WatchQualites.quaility1080, fromat: VideoFormat.hls)
    ]);
  }

  @override
  // TODO: implement name
  String get name => 'MockVideoExtractor';
}

class MockMovieProvider extends MovieProvider {
  @override
  String get hostUrl => '';

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    return const [
      Episode(number: 1, url: '62081'),
      Episode(number: 2, url: '62082'),
      Episode(number: 3, url: '62083'),
      Episode(number: 4, url: '62084'),
      Episode(number: 5, url: '62085'),
      Episode(number: 6, url: '62087'),
    ];
  }

  @override
  Future<Movie> loadMovie(String url) {
    // TODO: implement loadMovie
    throw UnimplementedError();
  }

  @override
  Future<List<Season>> loadSeasons(String url) async {
    return const [
      Season(number: 1, url: '2662'),
      Season(number: 2, url: "2663"),
      Season(number: 3, url: '2664'),
      Season(number: 4, url: '2665'),
      Season(number: 5, url: '59578'),
      Season(number: 6, url: '66730')
    ];
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return MockVideoExtractor(videoServer);
    // return VidCloud(videoServer);
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    return const [
      VideoServer(
        url: 'https://dokicloud.one/embed-4/eTorlYukbewt?z=',
        name: 'UpCloud',
      ),
      VideoServer(
        url: 'https://rabbitstream.net/embed-4/C0A3GBqVkJml?z=',
        name: 'VidCloud',
      )
    ];
  }

  @override
  String get name => 'MockProvider';

  @override
  Future<List<SearchResponse>> search(String query) async {
    return const [
      SearchResponse(
          title: 'Peaky Blinders',
          url: 'https://flixhq.click/peaky-blinders/',
          cover:
              'https://flixhq.click/wp-content/uploads/2022/12/11779-poster.jpg',
          type: MediaType.tvShow)
    ];
  }
}
