import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/generate_episode_chunks.dart';
import 'package:meiyou_extenstions/models.dart';

class EpisodesCubit extends Cubit<Map<String, List<Episode>>> {
  EpisodesCubit([List<Episode>? episodes]) : super({}) {
    if (episodes != null) {
      emit(GenerateEpisodesChunks.buildEpisodesResponse(episodes));
    }
  }

  void updateEpisodes(List<Episode> episodes) {
    emit(GenerateEpisodesChunks.buildEpisodesResponse(episodes));
  }
}
