import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/generate_episode_chunks.dart';
import 'package:meiyou/domain/entities/episode.dart';

class EpisodesCubit extends Cubit<Map<String, List<EpisodeEntity>>> {
  EpisodesCubit([List<EpisodeEntity>? episodes]) : super({}) {
    if (episodes != null) {
      emit(GenerateEpisodesChunks.buildEpisodesResponse(episodes));
    }
  }

  void updateEpisodes(List<EpisodeEntity> episodes) {
    emit(GenerateEpisodesChunks.buildEpisodesResponse(episodes));
  }
}
