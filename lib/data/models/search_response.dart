import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/show_type.dart';

class SearchResponse extends SearchResponseEntity {
  const SearchResponse({
    required super.title,
    required super.url,
    required super.poster,
    required super.type,
    super.description,
    super.generes,
    super.rating,
    super.current,
    super.total,
  });
  factory SearchResponse.fromEntity(SearchResponseEntity entity) {
    return createFromEntity<SearchResponseEntity, SearchResponse>(
      entity,
      SearchResponse(
        title: entity.title,
        url: entity.url,
        poster: entity.poster,
        type: entity.type,
        description: entity.description,
        generes: entity.generes,
        rating: entity.rating,
        current: entity.current,
        total: entity.total,
      ),
    );
  }

  @override
  String toString() {
    return '''SearchResponse(
     title: $title,
     url: $url,
     poster: $poster,
     type: $type,
     description: $description,
     generes: $generes,
     rating: $rating,
     current: $current,
     total: $total
  )''';
  }
}

