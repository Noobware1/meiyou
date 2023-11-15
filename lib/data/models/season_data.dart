import 'package:meiyou/domain/entities/season_data.dart';

class SeasonData extends SeasonDataEntity {
  SeasonData({super.season, super.name});

  @override
  String toString() {
    return '''SeasonData(season: $season, name: $name)''';
  }
}
