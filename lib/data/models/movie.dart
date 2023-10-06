import 'package:meiyou/domain/entities/movie.dart';

class Movie extends MovieEntity {
  const Movie(
      {required super.url,
      super.description,
      super.cover,
      super.title,
      super.rated});

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'description': description,
      'cover': cover,
      'title': title,
      'rated': rated,
    };
  }

  factory Movie.fromJson(dynamic json) {
    return Movie(
      url: json['url'] as String,
      description: json['description'] as String?,
      cover: json['cover'] as String?,
      title: json['title'] as String?,
      rated: json['rated'] as double?,
    );
  }

  @override
  String toString() {
    return '''Movie("url": $url,"cover": $cover,"description": $description,"rated": $rated,"title": $title)''';
  }
}
