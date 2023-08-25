import 'dart:async';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/utils/extenstions/episode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/core/utils/async_loop.dart';

class MyAnimeList {
  static const hostUrl = 'https://api.jikan.moe/v4';



  Future<List<Episode>?> fetchEpisode(MediaDetails media,
      [String? page]) async {
    final url = '$hostUrl/anime/${media.id}/episodes';

    final image = media.bannerImage ?? media.poster;

    final getEpisode = (await client.get(url)).json();

    final episodes = _parseEpisodeResponse(getEpisode)
        .mapAsList((episode) => episode.copyWith(thumbnail: image));

    final totalPages = int.parse(
        getEpisode?["pagination"]?["last_visible_page"]?.toString() ?? '0');

    final bool isNextPage =
        getEpisode?["pagination"]?["has_next_page"] ?? false;
    if (!isNextPage) return episodes;

    final list = [...episodes];
    await asyncForLoop(
      start: 2,
      end: totalPages,
      cancelOnError: false,
      onData: (data) => list.addAll(data),
      fun: (index) async => (await client.get('$url?page=$index'))
          .json(_parseEpisodeResponse)
          .mapAsList((it) => it.copyWith(thumbnail: image)),
    );
    list.fillMissingEpisode(media);
    final total = media.totalEpisode ?? media.currentNumberEpisode;

    if (total != null && list.length != total) list.fill(total, media);
    return list;
  
  }



List<Episode> _parseEpisodeResponse(dynamic json) =>
    List.from(json["data"]).mapAsList(_parseEpisode);

Episode _parseEpisode(dynamic json) {
  return Episode(
      number: json['mal_id'] as int,
      title: json?['title'] ?? json["title_romanji"],
      isFiller: json['filler'],
      rated: (json['score']?.toString() ?? '0.0').toDouble());
}


}

