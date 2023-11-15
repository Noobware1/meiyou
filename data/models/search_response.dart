import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/domain/entities/search_response.dart';

class SearchResponse extends SearchResponseEntity {
  const SearchResponse({
    required super.title,
    required super.url,
    required super.cover,
    required super.type,
  });

  factory SearchResponse.anime({
    required String title,
    required String url,
    required String cover,
  }) {
    return SearchResponse(
        title: title, url: url, cover: cover, type: MediaType.anime);
  }

  factory SearchResponse.fromEntity(SearchResponseEntity entity) {
    return SearchResponse(
      title: entity.title,
      url: entity.url,
      cover: entity.cover,
      type: entity.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'cover': cover,
      'type': type,
    };
  }

  factory SearchResponse.fromJson(dynamic json) {
    return SearchResponse(
      title: json['title'] as String,
      url: json['url'] as String,
      cover: json['cover'] as String,
      type: json['type'] as String,
    );
  }



  SearchResponse copyWith({
    String? title,
    String? url,
    String? cover,
    String? type,
  }) {
    return SearchResponse(
        title: title ?? this.title,
        url: url ?? this.url,
        cover: cover ?? this.cover,
        type: type ?? this.type);
  }

  @override
  String toString() =>
      'SearchResponse(title: $title, url: $url, cover: $cover, type: $type)';
}
