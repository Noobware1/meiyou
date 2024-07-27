import 'package:isar/isar.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';
part 'media.g.dart';

abstract class Media extends IMedia {
  Media._({
    this.id = Isar.autoIncrement,
    required this.sourceId,
    super.format,
    super.title,
    super.url,
    super.otherTitles,
    Status status = Status.unknown,
    super.banner,
    super.poster,
    super.score,
    super.description,
    super.genres,
  }) : super(status: status);

  factory Media({
    Id id = Isar.autoIncrement,
    required int sourceId,
    required ExtensionCategory category,
    MediaFormat format = MediaFormat.others,
    String title = '',
    String url = '',
    List<String>? otherTitles,
    Status status = Status.unknown,
    String? banner,
    String? poster,
    double? score,
    String? description,
    List<String>? genres,
  }) {
    return category.when<Media>(
      video: () => VideoMedia(
        id: id,
        sourceId: sourceId,
        format: format,
        title: title,
        url: url,
        otherTitles: otherTitles,
        status: status,
        banner: banner,
        poster: poster,
        description: description,
        score: score,
        genres: genres,
      ),
      manga: () => MangaMedia(
        id: id,
        sourceId: sourceId,
        format: format,
        title: title,
        url: url,
        otherTitles: otherTitles,
        status: status,
        banner: banner,
        poster: poster,
        description: description,
        score: score,
        genres: genres,
      ),
      novel: () => NovelMedia(
        id: id,
        sourceId: sourceId,
        format: format,
        title: title,
        url: url,
        otherTitles: otherTitles,
        status: status,
        banner: banner,
        poster: poster,
        description: description,
        score: score,
        genres: genres,
      ),
    );
  }

  String? get bannerOrPoster => banner ?? poster;

  @ignore
  ExtensionCategory get category => when(
        video: (_) => ExtensionCategory.video,
        manga: (_) => ExtensionCategory.manga,
        novel: (_) => ExtensionCategory.novel,
      );

  Id id;
  int sourceId;

  R when<R>({
    required R Function(VideoMedia) video,
    required R Function(MangaMedia) manga,
    required R Function(NovelMedia) novel,
  });

  @override
  Status get status => super.status!;

  @override
  set status(Status? status) {
    super.status = status ?? Status.unknown;
  }

  factory Media.formIMedia(
      IMedia media, int sourceId, ExtensionCategory category) {
    return Media(
      sourceId: sourceId,
      category: category,
      banner: media.banner,
      description: media.description,
      format: media.format,
      genres: media.genres,
      otherTitles: media.otherTitles,
      poster: media.poster,
      score: media.score,
      status: media.status ?? Status.unknown,
      title: media.title,
      url: media.url,
    );
  }

  Media copyDetails(IMedia media) {
    return apply((it) {
      it.banner = media.banner ?? it.banner;
      it.description = media.description ?? it.description;
      it.genres = media.genres ?? it.genres;
      it.otherTitles = media.otherTitles ?? it.otherTitles;
      it.poster = media.poster ?? it.poster;
      it.score = media.score ?? it.score;
      it.status = media.status ?? it.status;
      it.title = media.title.isNotEmpty ? media.title : it.title;
      it.url = media.url.isNotEmpty ? media.url : it.url;
      it.format =
          media.format == MediaFormat.others && it.format == MediaFormat.others
              ? media.format
              : it.format;
    });
  }
}

@collection
class VideoMedia extends Media {
  VideoMedia({
    super.id,
    required super.sourceId,
    super.format,
    super.title,
    super.url,
    super.otherTitles,
    super.status,
    super.banner,
    super.poster,
    super.score,
    super.description,
    super.genres,
  }) : super._();

  @override
  R when<R>({
    required R Function(VideoMedia) video,
    required R Function(MangaMedia) manga,
    required R Function(NovelMedia) novel,
  }) {
    return video(this);
  }

  @enumerated
  @override
  MediaFormat get format => super.format;

  @enumerated
  @override
  Status get status => super.status;
}

@collection
class MangaMedia extends Media {
  MangaMedia({
    super.id,
    required super.sourceId,
    super.format,
    super.title,
    super.url,
    super.otherTitles,
    super.status,
    super.banner,
    super.poster,
    super.score,
    super.description,
    super.genres,
  }) : super._();

  @override
  R when<R>({
    required R Function(VideoMedia) video,
    required R Function(MangaMedia) manga,
    required R Function(NovelMedia) novel,
  }) {
    return manga(this);
  }

  @enumerated
  @override
  MediaFormat get format => super.format;

  @enumerated
  @override
  Status get status => super.status;
}

@collection
class NovelMedia extends Media {
  NovelMedia({
    super.id,
    required super.sourceId,
    super.format,
    super.title,
    super.url,
    super.otherTitles,
    super.status,
    super.banner,
    super.poster,
    super.score,
    super.description,
    super.genres,
  }) : super._();

  @override
  R when<R>({
    required R Function(VideoMedia) video,
    required R Function(MangaMedia) manga,
    required R Function(NovelMedia) novel,
  }) {
    return novel(this);
  }

  @enumerated
  @override
  MediaFormat get format => super.format;

  @enumerated
  @override
  Status get status => super.status;
}
