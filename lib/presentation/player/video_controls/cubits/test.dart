import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/season.dart';

void main(List<String> args) {
  fun(int index, bool moveNext) {
    final episodes =
        List.generate(10, (index) => EpisodeEntity(number: index + 1));

    final seasons =
        List.generate(5, (index) => SeasonEntity(number: index + 1));

    final season = seasons.indexOf(seasons[2]);

    if (moveNext && index == episodes.length - 1) {
      final hasNext = seasons.containsIndex(season + 1);
    }
  }

  print(0 - 1);
}
