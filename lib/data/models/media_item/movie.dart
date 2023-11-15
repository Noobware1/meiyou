import 'package:meiyou/domain/entities/media_item.dart';

class Movie extends MediaItemEntity {
  final String url;
  final String? posterImage;

  final String? description;

  Movie({required this.url, this.posterImage, this.description})
      : super(type: MediaItemType.Movie);

  @override
  String toString() {
    return 'Movie(url: $url, description: $description, posterImage: $posterImage)';
  }
}

