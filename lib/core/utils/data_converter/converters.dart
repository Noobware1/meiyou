import 'package:meiyou/core/utils/data_converter/episode_list_converter.dart';
import 'package:meiyou/core/utils/data_converter/movie_writer.dart';
import 'package:meiyou/core/utils/data_converter/search_response_list_writer.dart';
import 'package:meiyou/core/utils/data_converter/season_episode_map_converter.dart';
import 'package:meiyou/core/utils/data_converter/video_server_video_container_map_writer.dart';
import 'season_list_converter.dart';

class CacheWriters {
  static EpisodeListWriter episodeListWriter = EpisodeListWriter();
  static SeasonListWriter seasonListWriter = SeasonListWriter();
  static SeasonEpisodeMapWriter seasonEpisodeWriter = SeasonEpisodeMapWriter();
  static MovieWriter movieWriter = MovieWriter();
  static SearchResponseListWriter searchResponseListWriter =
      SearchResponseListWriter();
  static VideoServerVideoContainerMapWriter videoServerVideoContainerMapWriter =
      VideoServerVideoContainerMapWriter();
}
