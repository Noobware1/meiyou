import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/utils/comparing_strings.dart';
import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/data/models/results.dart';

MetaResponse? findBestMatchingTitle(
    List<MetaResponse> responses, String target) {
  final titles =
      responses.map((e) => e.title ?? e.romanji ?? e.native!).toList();
  final index = findBestMatch(target, titles).index;

  return responses[index];
}

bool matchByReleaseDate(DateTime? releaseDate, MetaResponse response) {
  if (response.airDate == null || releaseDate == null) {
    return false;
  }
  return response.airDate!.year == releaseDate.year;
}

List<MetaResponse>? filterResults(
    DateTime? releaseDate, MetaResults response, MediaProvider type) {
  final results = <MetaResponse>[];
  for (var i = 0; i < response.metaResponses.length; i++) {
    final value = response.metaResponses[i] as MetaResponse;

    if (type == MediaProvider.tmdb &&
        value.isAnime() &&
        matchByReleaseDate(releaseDate, value)) {
      results.add(value);
    } else if (type == MediaProvider.anilist &&
        matchByReleaseDate(releaseDate, value)) {
      results.add(value);
    }
  }
  return results.isEmpty ? null : results;
}
