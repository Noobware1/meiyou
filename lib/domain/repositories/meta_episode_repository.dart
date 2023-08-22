import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/domain/entities/media_details.dart';

abstract interface class MetaEpisodeRepository {
  Future<ResponseState<List<Episode>>> getEpisodes(MediaDetailsEntity media);
}
