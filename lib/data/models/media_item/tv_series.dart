import 'package:meiyou/data/models/season_list.dart';
import 'package:meiyou/domain/entities/media_item.dart';

class TvSeries extends MediaItemEntity {
  final List<SeasonList> data;

  TvSeries({required this.data}) : super(type: MediaItemType.TvSeries);


@override
  String toString() {
    return '''TvSeries(data: $data)''';
  }
}

