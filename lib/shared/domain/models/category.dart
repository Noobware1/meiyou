import 'dart:ffi';

import 'package:isar/isar.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
part 'category.g.dart';

abstract class Category {
  final Id id;
  String name;
  bool hidden;

  Category._({required this.id, required this.name, required this.hidden});

  factory Category({
    Id id = Isar.autoIncrement,
    required ExtensionCategory category,
    required String name,
    bool hidden = false,
  }) {
    return category.when<Category>(
      video: () => VideoCategory(id: id, name: name, hidden: hidden),
      manga: () => MangaCategory(id: id, name: name, hidden: hidden),
      novel: () => NovelCategory(id: id, name: name, hidden: hidden),
    );
  }

  R when<R>({
    required R Function(VideoCategory) video,
    required R Function(MangaCategory) manga,
    required R Function(NovelCategory) novel,
  });
}

@collection
class VideoCategory extends Category {
  VideoCategory({required super.id, required super.name, required super.hidden})
      : super._();

  @override
  R when<R>({
    required R Function(VideoCategory) video,
    required R Function(MangaCategory) manga,
    required R Function(NovelCategory) novel,
  }) =>
      video(this);
}

@collection
class MangaCategory extends Category {
  MangaCategory({required super.id, required super.name, required super.hidden})
      : super._();

  @override
  R when<R>({
    required R Function(VideoCategory) video,
    required R Function(MangaCategory) manga,
    required R Function(NovelCategory) novel,
  }) =>
      manga(this);
}

@collection
class NovelCategory extends Category {
  NovelCategory({required super.id, required super.name, required super.hidden})
      : super._();

  @override
  R when<R>({
    required R Function(VideoCategory) video,
    required R Function(MangaCategory) manga,
    required R Function(NovelCategory) novel,
  }) =>
      novel(this);
}
