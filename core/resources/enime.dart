import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/data/models/episode.dart';

class Enime {
  static const hostUrl = 'https://api.enime.moe';

  Future<List<Episode>?> fetchEpisodeByAnilistId(int id,
      [String? image, double? score]) async {
    try {
      final response =
          (await client.get('$hostUrl/mapping/anilist/$id')).json();

      final episodes = List<dynamic>.from(response['episodes'])
          .map((json) => Episode(
                number: json['number'] as num,
                title: json['title']?.toString() ?? '',
                thumbnail: json['image']?.toString() ?? image ?? '',
                desc: json['description']?.toString() ?? '',
                isFiller: false,
              ))
          .toList()
        ..sort((a, b) => a.number.toInt().compareTo(b.number.toInt()));
      if (episodes.isNotEmpty) return episodes;
      return null;
    } catch (_) {
      return null;
    }
  }
}
