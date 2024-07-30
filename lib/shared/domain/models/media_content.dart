// ignore_for_file: overridden_fields, unnecessary_overrides

import 'package:isar/isar.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou_extensions_lib/models.dart';
part 'media_content.g.dart';

abstract class MediaContent extends IMediaContent {
  final Id id;
  final int mediaId;
  @override
  int get number => super.number as int;
  final int lastSecondsSeen;
  final int sourceOrder;
  final int totalSeconds;
  @override
  String? get name => super.name;
  @override
  String? get description => super.description;
  @override
  String get url => super.url;
  @override
  int get season => super.season as int;
  @override
  bool get isFiller => super.isFiller as bool;
  final bool seen;

  MediaContent._({
    this.id = Isar.autoIncrement,
    required this.mediaId,
    required int super.number,
    required this.sourceOrder,
    required this.lastSecondsSeen,
    required this.totalSeconds,
    required super.name,
    required super.description,
    required super.url,
    required bool super.isFiller,
    required int super.season,
    required super.image,
    required this.seen,
  });

  factory MediaContent({
    Id id = Isar.autoIncrement,
    required ExtensionCategory category,
    required int mediaId,
    required int number,
    required int lastSecondsSeen,
    required int sourceOrder,
    required int totalSeconds,
    required String? name,
    required String? description,
    required String url,
    required int season,
    required bool isFiller,
    required String? image,
    required bool seen,
  }) {
    return category.when(
      video: () => VideoContent(
        id: id,
        mediaId: mediaId,
        number: number,
        lastSecondsSeen: lastSecondsSeen,
        sourceOrder: sourceOrder,
        totalSeconds: totalSeconds,
        url: url,
        season: season,
        name: name,
        description: description,
        isFiller: isFiller,
        image: image,
        seen: seen,
      ),
      manga: () => MangaContent(
        id: id,
        mediaId: mediaId,
        number: number,
        lastSecondsSeen: lastSecondsSeen,
        sourceOrder: sourceOrder,
        totalSeconds: totalSeconds,
        url: url,
        season: season,
        name: name,
        description: description,
        isFiller: isFiller,
        image: image,
        seen: seen,
      ),
      novel: () => NovelContent(
        id: id,
        mediaId: mediaId,
        number: number,
        lastSecondsSeen: lastSecondsSeen,
        sourceOrder: sourceOrder,
        totalSeconds: totalSeconds,
        url: url,
        season: season,
        name: name,
        description: description,
        isFiller: isFiller,
        image: image,
        seen: seen,
      ),
    );
  }

  @ignore
  ExtensionCategory get category => when(
        video: (_) => ExtensionCategory.video,
        manga: (_) => ExtensionCategory.manga,
        novel: (_) => ExtensionCategory.novel,
      );

  T when<T>({
    required T Function(VideoContent) video,
    required T Function(MangaContent) manga,
    required T Function(NovelContent) novel,
  });

  MediaContent copyWith({
    Id? id,
    int? mediaId,
    int? number,
    int? lastSecondsSeen,
    int? sourceOrder,
    int? totalSeconds,
    String? name,
    int? season,
    String? description,
    String? url,
    bool? isFiller,
    bool? seen,
    String? image,
  });
}

@collection
class VideoContent extends MediaContent {
  VideoContent({
    super.id,
    required super.mediaId,
    required super.number,
    required super.lastSecondsSeen,
    required super.sourceOrder,
    required super.totalSeconds,
    super.name,
    super.description,
    required super.url,
    required super.season,
    required super.isFiller,
    required super.seen,
    required super.image,
  }) : super._();

  @override
  MediaContent copyWith(
      {Id? id,
      int? mediaId,
      int? number,
      int? lastSecondsSeen,
      int? sourceOrder,
      int? totalSeconds,
      String? name,
      int? season,
      String? description,
      String? url,
      bool? isFiller,
      String? image,
      bool? seen}) {
    return VideoContent(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      number: number ?? this.number,
      lastSecondsSeen: lastSecondsSeen ?? this.lastSecondsSeen,
      sourceOrder: sourceOrder ?? this.sourceOrder,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      name: name ?? this.name,
      season: season ?? this.season,
      description: description ?? this.description,
      url: url ?? this.url,
      isFiller: isFiller ?? this.isFiller,
      seen: seen ?? this.seen,
      image: image ?? this.image,
    );
  }

  @override
  T when<T>(
      {required T Function(VideoContent p1) video,
      required T Function(MangaContent p1) manga,
      required T Function(NovelContent p1) novel}) {
    return video(this);
  }
}

@collection
class MangaContent extends MediaContent {
  MangaContent({
    super.id,
    required super.mediaId,
    required super.number,
    required super.lastSecondsSeen,
    required super.sourceOrder,
    required super.totalSeconds,
    super.name,
    super.description,
    required super.url,
    required super.season,
    required super.isFiller,
    required super.seen,
    required super.image,
  }) : super._();

  @override
  MediaContent copyWith(
      {Id? id,
      int? mediaId,
      int? number,
      int? lastSecondsSeen,
      int? sourceOrder,
      int? totalSeconds,
      String? name,
      int? season,
      String? description,
      String? url,
      bool? isFiller,
      String? image,
      bool? seen}) {
    return MangaContent(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      number: number ?? this.number,
      lastSecondsSeen: lastSecondsSeen ?? this.lastSecondsSeen,
      sourceOrder: sourceOrder ?? this.sourceOrder,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      name: name ?? this.name,
      season: season ?? this.season,
      description: description ?? this.description,
      url: url ?? this.url,
      isFiller: isFiller ?? this.isFiller,
      image: image ?? this.image,
      seen: seen ?? this.seen,
    );
  }

  @override
  T when<T>(
      {required T Function(VideoContent p1) video,
      required T Function(MangaContent p1) manga,
      required T Function(NovelContent p1) novel}) {
    return manga(this);
  }
}

@collection
class NovelContent extends MediaContent {
  NovelContent({
    super.id,
    required super.mediaId,
    required super.number,
    required super.lastSecondsSeen,
    required super.sourceOrder,
    required super.totalSeconds,
    super.name,
    super.description,
    required super.url,
    required super.season,
    required super.isFiller,
    required super.seen,
    required super.image,
  }) : super._();

  @override
  MediaContent copyWith(
      {Id? id,
      int? mediaId,
      int? number,
      int? lastSecondsSeen,
      int? sourceOrder,
      int? totalSeconds,
      String? name,
      int? season,
      String? description,
      String? url,
      bool? isFiller,
      String? image,
      bool? seen}) {
    return NovelContent(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      number: number ?? this.number,
      lastSecondsSeen: lastSecondsSeen ?? this.lastSecondsSeen,
      sourceOrder: sourceOrder ?? this.sourceOrder,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      name: name ?? this.name,
      season: season ?? this.season,
      description: description ?? this.description,
      url: url ?? this.url,
      isFiller: isFiller ?? this.isFiller,
      image: image ?? this.image,
      seen: seen ?? this.seen,
    );
  }

  @override
  T when<T>(
      {required T Function(VideoContent p1) video,
      required T Function(MangaContent p1) manga,
      required T Function(NovelContent p1) novel}) {
    return novel(this);
  }
}
