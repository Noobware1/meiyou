
class SeasonDataEntity {
  final num? season;
  final String? name;

  SeasonDataEntity({this.season, this.name});

  @override
  String toString() {
    return '''SeasonData(season: $season, name: $name)''';
  }
}