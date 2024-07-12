import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/preference.dart';

final class LibraryPreferences {
  final PreferenceStore _store;

  LibraryPreferences(this._store);

  Preference<ExtensionType> lastUsedExtensionType() => _store.getEnum(
        Preference.appStateKey('last_used_extension_type'),
        ExtensionType.Video,
        ExtensionType.values,
      );

  Preference<List<String>> getLibraryCategories(ExtensionType type) {
    switch (type) {
      case ExtensionType.Video:
        return videoLibraryCategories();
      case ExtensionType.Manga:
        return mangaLibraryCategories();
      case ExtensionType.Novel:
        return novelLibraryCategories();
    }
  }

  Preference<List<String>> videoLibraryCategories() => _store.getStringList(
        Preference.appStateKey('video_lib_categories'),
        [],
      );

  Preference<int> defaultVideoLibraryCategory() => _store.getInt(
        Preference.appStateKey('default_video_category'),
        -1,
      );

  Preference<List<String>> mangaLibraryCategories() => _store.getStringList(
        Preference.appStateKey('manga_lib_categories'),
        [],
      );

  Preference<int> defaultMangaLibraryCategory() => _store.getInt(
        Preference.appStateKey('default_manga_category'),
        -1,
      );

  Preference<List<String>> novelLibraryCategories() => _store.getStringList(
        Preference.appStateKey('novel_lib_categories'),
        [],
      );

  Preference<int> defaultNovelLibraryCategory() => _store.getInt(
        Preference.appStateKey('default_novel_category'),
        -1,
      );
}
