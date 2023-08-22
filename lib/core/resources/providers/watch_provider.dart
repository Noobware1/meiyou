import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';

import 'package:meiyou/data/models/video_server.dart';

abstract class WatchProvider extends BaseProvider {
  String get hostUrl;

  // Future<List<SearchResponse>> search(String query);

  // Future<List<Episode>> loadEpisodes(String url);

  Future<List<VideoServer>> loadVideoServer(String url);

  VideoExtractor loadVideoExtractor(VideoServer videoServer);
  // Future<List<VideoServer>> loadVideoServer(String url);

  // Future<List<VideoExtractor>> loadVideoExtractor(VideoServer videoServer);
}
