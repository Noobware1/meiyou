import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';

Future<List<Episode>> mapEpisodes(MediaDetails media, int id, TMDB tmdb) async {
  final episodes = await tmdb.fetchEpisodes(MediaDetails(
      id: id,
      mediaProvider: MediaProvider.tmdb,
      status: '',
      mediaType: '',
      genres: const ['']));

  final len = media.totalEpisode ?? media.currentNumberEpisode!;

  final inRangeEpisdes =
      episodes.where((element) => element.number.toInt() <= len).toList();

  final isNotEqual = inRangeEpisdes.length < len;

  if (isNotEqual) inRangeEpisdes.fill(len, media);

  inRangeEpisdes.sort((a, b) => a.number.toInt().compareTo(b.number.toInt()));

  return inRangeEpisdes;
}

List<Episode> defaultEpisodeGeneration(MediaDetails media, int len) {
  return List.generate(len, (i) {
    final episodeNumber = i + 1;
    return Episode(
        number: episodeNumber,
        title: 'Episode $episodeNumber',
        thumbnail: media.bannerImage ?? media.poster);
  });
}
