import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/domain/entities/media_item.dart';

class Anime extends MediaItemEntity {
  final List<Episode> episodes;
  Anime({required this.episodes}) : super(type: MediaItemType.Anime);

  @override
  String toString() {
    return 'Anime(episodes: $episodes)';
  }
}

