import 'package:meiyou/core/utils/resources/locale_helper.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class SourcePreferences {
  final PreferenceStore _store;

  SourcePreferences(this._store);

  Preference<List<String>> extensionsRepos() =>
      _store.getStringList('extensions_repos', []);

  Preference<List<String>> enabledLanguages() => _store.getStringList(
      "source_languages", LocaleHelper.getDefaultEnabledLanguages().toList());

  Preference<int> lastUsedSourceByType(ExtensionType type) {
    switch (type) {
      case ExtensionType.Video:
        return lastUsedVideoSource();
      case ExtensionType.Manga:
        return lastUsedMangaSource();
      case ExtensionType.Novel:
        return lastUsedNovelSource();
      default:
        throw type.invailedTypeError();
    }
  }

  Preference<ExtensionType> lastUsedExtensionType() => _store.getEnum(
        Preference.appStateKey('last_used_extension_type'),
        ExtensionType.Video,
        ExtensionType.values,
      );

  Preference<int> lastUsedVideoSource() =>
      _store.getInt(Preference.appStateKey('last_used_video_source'), -1);

  Preference<int> lastUsedMangaSource() =>
      _store.getInt(Preference.appStateKey('last_used_manga_source'), -1);

  Preference<int> lastUsedNovelSource() =>
      _store.getInt(Preference.appStateKey('last_used_novel_source'), -1);
}
