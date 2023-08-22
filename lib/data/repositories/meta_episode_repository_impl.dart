import 'dart:async';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/mapping/map_episodes.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/repositories/meta_episode_repository.dart';

class MetaEpisodeRepositoryImpl implements MetaEpisodeRepository {
  final TMDB _tmdb;
  final Anilist _anilist;

  const MetaEpisodeRepositoryImpl(this._anilist, this._tmdb);

  @override
  Future<ResponseState<List<Episode>>> getEpisodes(MediaDetailsEntity media) {
    return tryWithAsync(() {
      if (media.mediaProvider == MediaProvider.anilist) {
        return _anilist.fetchEpisodes(media as MediaDetails);
      }

      final Completer<List<Episode>> completer = Completer();
      final List<Episode> episodes = [];
      _episodeStream(media as MediaDetails).listen(
        (data) {
          episodes.addAll(data);
        },
        onDone: () => completer.complete(episodes),
      );

      return completer.future.timeout(const Duration(minutes: 30));
    });
  }

  Stream<List<Episode>> _episodeStream(MediaDetails media) async* {
    assert(media.seasons != null);
    for (var i = 0; i < media.seasons!.length; i++) {
      final season = media.seasons![i];
      final episodes = await _tmdb.fetchEpisodes(media, season as Season);
      if (episodes is ResponseSuccess) {
        yield episodes;
      } else {
        defaultEpisodeGeneration(media, season.totalEpisode ?? 1);
      }
    }
  }
}
