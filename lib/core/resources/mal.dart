import 'dart:async';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';

class MyAnimeList {
  static const hostUrl = 'https://api.jikan.moe/v4';

  Stream<List<Episode>> _getEpisode(
      int total, String url, String? thumbnail) async* {
    for (var i = 2; i < total + 1; i++) {
      Future.delayed(const Duration(seconds: 2));
      final res = (await client.get('$url?page=$i')).json();
      final episodes = _parseEpisodeResponse(res);
      if (episodes != null) {
        yield episodes
            .map((episode) => episode.copyWith(thumbnail: thumbnail))
            .toList();
      }
    }
  }

  Future<List<Episode>?> fetchEpisode(MediaDetails media,
      [String? page]) async {
    final url = '$hostUrl/anime/${media.id}/episodes';

    final image = media.bannerImage ?? media.poster;

    final getEpisode = (await client.get(url)).json();

    final episodes = _parseEpisodeResponse(getEpisode)
        ?.map((episode) => episode.copyWith(thumbnail: image))
        .toList();

    final totalPages = int.parse(
        getEpisode?["pagination"]?["last_visible_page"]?.toString() ?? '0');

    final bool isNextPage =
        getEpisode?["pagination"]?["has_next_page"] ?? false;
    if (!isNextPage) return episodes;
    final Completer<List<Episode>> completer = Completer();

    if (episodes != null) {
      final list = [...episodes];
      _getEpisode(totalPages, url, image).listen((event) {
        list.addAll(event);
      }, onDone: () {
        final newList = list.fillMissingEpisode(media);
        final total = media.totalEpisode ?? media.currentNumberEpisode!;

        if (newList.length != total) newList.fill(total, media);

        completer.complete(newList);
      });

      return completer.future;
    } else {
      return null;
    }
  }

  List<Episode>? _parseEpisodeResponse(dynamic json) {
    if (json["data"] != null) {
      final data =
          List.from(json["data"]).map((e) => _parseEpisode(e)).toList();
      return data;
    } else {
      return null;
    }
  }

  Episode _parseEpisode(dynamic json) {
    return Episode(
        number: json['mal_id'] as int,
        title: json?['title'] ?? json["title_romanji"],
        isFiller: json['filler'],
        rated: (json['score']?.toString() ?? '0.0').toDouble());
  }
}
