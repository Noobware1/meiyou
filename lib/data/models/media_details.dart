import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/core/utils/unwrap.dart';
import 'package:meiyou/data/models/actor_data.dart';
import 'package:meiyou/data/models/external_id.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/domain/entities/actor_data.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/show_type.dart';

class MediaDetails extends MediaDetailsEntity {
  MediaDetails({
    super.type = ShowType.Others,
    super.name = '',
    super.url = '',
    super.otherTitles,
    super.status,
    super.bannerImage,
    super.posterImage,
    super.rating,
    super.description,
    super.startDate,
    super.endDate,
    super.duration,
    super.genres,
    List<SearchResponse>? recommendations,
    List<ExternalId>? externalIds,
    List<ActorData>? actorData,
    super.mediaItem,
  }) : super(
            recommendations: recommendations,
            externalIds: externalIds,
            actorData: actorData);

  @override
  List<SearchResponse>? get recommendations =>
      super.recommendations?.mapAsList((e) => e as SearchResponse);

  @override
  List<ExternalId>? get externalIds => super.externalIds as List<ExternalId>?;

  @override
  List<ActorData>? get actorData => super.actorData?.mapAsList((it) => it as ActorData);

  void copyFromSearchResponse(SearchResponse searchResponse) {
    name = searchResponse.title;
    posterImage = searchResponse.poster;
    url = searchResponse.url;
    type = searchResponse.type;
  }

  @override
  String toString() {
    return '''MediaDetails(
      type: $type,
      name: $name,
      url: $url,
      otherTitles: $otherTitles,
      status: $status,
      bannerImage: $bannerImage,
      posterImage: $posterImage,
      rating: $rating,
      description: $description,
      startDate: $startDate,
      endDate: $endDate,
      duration: $duration,
      genres: $genres,
      recommendations: ${recommendations != null ? unwrapList<SearchResponse>(recommendations!) : null},
      externalIds: ${externalIds != null ? unwrapList<ExternalId>(externalIds!) : null},
      actorData: ${actorData != null ? unwrapList<ActorData>(actorData!) : null},
      mediaItem: ${mediaItem != null ? unwrapValue(mediaItem) : null},
    )''';
  }
}
