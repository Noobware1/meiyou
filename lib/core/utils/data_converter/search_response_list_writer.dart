
import 'package:meiyou/core/utils/data_converter/data_convert.dart';
import 'package:meiyou/data/models/search_response.dart';

class SearchResponseListWriter extends CacheWriter<List<SearchResponse>> {
  @override
  List<SearchResponse> readFromJson(json) {
    final responses = <SearchResponse>[];
    for (final response in (json as List)) {
      responses.add(SearchResponse.fromJson(response));
    }
    return responses;
  }

  @override
  String writeToJson(List<SearchResponse> data) {
    final map = <Map<String, dynamic>>[];
    for (final response in data) {
      map.add(response.toJson());
    }
    return jsonEncoder.encode(map);
  }
}
