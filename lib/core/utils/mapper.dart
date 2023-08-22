import 'package:meiyou/core/utils/comparing_strings.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/data/models/meta_response.dart';

class Mapper {
  MetaResponse? findBestAnilistResponse(
      List<MetaResponse> responses, MetaResponse response) {
    final filterResponse = _filterByRealeaseDate(responses, response.airDate);
    if (filterResponse.isEmpty) return null;
  }

  List<MetaResponse> _filterByRealeaseDate(
      List<MetaResponse> responses, DateTime? realeaseDate) {
    return responses.whereSafe((it) => it.airDate?.year == realeaseDate?.year);
  }

  _compareTitles(List<MetaResponse> responses, MetaResponse response) {
    final list =
        responses.map((it) => it.title ?? it.romanji ?? it.native!).toList();
    final title = response.title ?? response.romanji ?? response.native!;
    for (var i = 0; i < list.length; i++) {
      final stats = compareTwoStrings(list[i], title);
    }
  }
}
