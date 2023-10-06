import 'package:meiyou/core/utils/comparing_strings.dart';
import 'package:meiyou/domain/entities/search_response.dart';

SearchResponseEntity findBestSearchResponse(
    List<SearchResponseEntity> searchResponses, String title) {
  assert(searchResponses.isNotEmpty);
  final titles = searchResponses.map((it) => it.title).toList();
  final match = findBestMatch(title, titles);
  return searchResponses[match.index];
}
