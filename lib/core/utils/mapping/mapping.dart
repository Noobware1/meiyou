import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/utils/mapping/functions.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/meta_response.dart';

class MappingRepository {
  final TMDB _tmdb;
  final Anilist _anilist;
  const MappingRepository(this._anilist, this._tmdb);

  Future<MediaDetails> mapAnilistToTmdb(MediaDetails media) async {
    final search = (await _tmdb.fetchSearch(media.mediaTitle))
        .metaResponses
        .where((e) =>
            e.airDate != null &&
            e.airDate?.year == media.startDate?.year &&
            (e as MetaResponse).isAnime() &&
            e.mediaType == MediaType.tvShow)
        .toList();
    List<String> titles = [];

    for (var i = 0; i < search.length; i++) {
      titles
          .add(search[i].title ?? search[i].romanji ?? search[i].native ?? '');
    }
    final best =
        findBestMatchingTitle(search as List<MetaResponse>, media.mediaTitle);
    if (best == null) return media;

    return media.copyWith(extrenalIds: {
      ...(media.extrenalIds ?? {}),
      'tmdb': best.id.toString()
    });
  }

  Future<List<Episode>> getAllSeasons(MediaDetails media) async {
    final List<Episode> mappedEpisodes = [];

    for (var i = 0; i < media.seasons!.length; i++) {
      try {
        mappedEpisodes
            .addAll(await _tmdb.fetchEpisodes(media, media.seasons![i]));
      } catch (_) {}
    }
    assert(mappedEpisodes.isNotEmpty);
    return mappedEpisodes;
  }
}

void main(List<String> args) async {
  await Future.delayed(const Duration(minutes: 5));
  final a = Anilist();
  final res = await a.fetchMediaDetails(21, '');

  final b = MappingRepository(Anilist(), TMDB());
  final Stopwatch stopwatch = Stopwatch()..start();
  final episodes = await b.mapAnilistToTmdb(res);
  stopwatch.stop();
  print(stopwatch.elapsed);
  print('');
  print('');
  print('');
  print('');
  print('');
  print('');

  // episodes?.forEach(print);
}
