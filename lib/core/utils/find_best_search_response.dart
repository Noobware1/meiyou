import 'package:meiyou/core/utils/comparing_strings.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/domain/entities/search_response.dart';

SearchResponseEntity findBestSearchResponse(
    List<SearchResponseEntity> searchResponses, String title) {
  assert(searchResponses.isNotEmpty);
  final titles = searchResponses.mapAsList((it) => it.title);
  final match = findBestMatch(title, titles);
  return searchResponses[match.index];
}
