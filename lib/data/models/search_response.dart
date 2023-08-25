import 'package:meiyou/domain/entities/search_response.dart';

class SearchResponse extends SearchResponseEntity {
  const SearchResponse({
    required super.title,
    required super.url,
    required super.cover,
    required super.type,
  });

  factory SearchResponse.fromEntity(SearchResponseEntity entity) {
    return SearchResponse(
      title: entity.title,
      url: entity.url,
      cover: entity.cover,
      type: entity.type,
    );
  }

  @override
  String toString() =>
      'title: $title,\n url: $url,\n cover: $cover,\n type: $type\n';
}
