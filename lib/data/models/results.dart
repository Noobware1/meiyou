import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/domain/entities/results.dart';

class MetaResults extends MetaResultsEntity {
  const MetaResults({
    required super.totalPage,
    required List<MetaResponse> metaResponses,
  }) : super(metaResponses: metaResponses);

  factory MetaResults.fromTMDB(dynamic json, String? type) => MetaResults(
      metaResponses: (json['results'] as List)
          .map((it) => MetaResponse.fromTMDB(it, type))
          .toList(),
      totalPage: json['total_pages'] as int? ?? 1);

  factory MetaResults.fromAnilist(dynamic json) {
    assert(json != null);

    final data = json['data']['Page'];

    final total = json['pageInfo']?['total'] as int? ?? 1;
    // final hasNextPage = pageInfo?['hasNextPage'];
    final media = data['media'] as List;

    final results = media.map((it) => MetaResponse.fromAnilist(it)).toList();

    return MetaResults(totalPage: total, metaResponses: results);
  }

  factory MetaResults.fromAnilistRecentlyUpdated(dynamic json) {
    assert(json != null);
    final data = json['data']?['Page'];
    // final pageInfo = data?;
    final total = data['pageInfo']?['total'] as int? ?? 1;
    // final hasNextPage = pageInfo?['hasNextPage'];
    final response = (data['airingSchedules'] as List)
        .map((it) => MetaResponse.fromAnilist(it['media']))
        .toList()
        .where((it) =>
            it.countryOfOrigin == 'JP' &&
            it.type == 'ANIME' &&
            it.isAdult == false)
        .toList();

    return MetaResults(totalPage: total, metaResponses: response);
  }
}
