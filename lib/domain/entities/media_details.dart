import 'package:meiyou/domain/entities/actor_data.dart';
import 'package:meiyou/domain/entities/external_id.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/show_status.dart';
import 'package:meiyou/domain/entities/show_type.dart';
import 'package:meiyou/domain/entities/media_item.dart';

class MediaDetailsEntity {
  ShowType type;
  String name;
  String url;
  List<String>? otherTitles;
  ShowStatus? status;
  String? bannerImage;
  String? posterImage;
  double? rating;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  Duration? duration;
  List<String>? genres;
  List<SearchResponseEntity>? recommendations;
  List<ExternalIdEntity>? externalIds;
  List<ActorDataEntity>? actorData;
  MediaItemEntity? mediaItem;

  MediaDetailsEntity({
    required this.type,
    required this.name,
    required this.url,
    this.otherTitles,
    this.status,
    this.bannerImage,
    this.posterImage,
    this.rating,
    this.description,
    this.startDate,
    this.endDate,
    this.duration,
    this.genres,
    this.recommendations,
    this.externalIds,
    this.actorData,
    this.mediaItem,
  });
}
