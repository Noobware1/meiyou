import 'package:meiyou/core/helper/locale_helper.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class SourcePreferences {
  final PreferenceStore _store;

  SourcePreferences(this._store);

  Preference<List<String>> extensionsRepos() =>
      _store.getStringList('extensions_repos', []);

  Preference<List<String>> enabledLanguages() => _store.getStringList(
      "source_languages", LocaleHelper.getDefaultEnabledLanguages().toList());

  Preference<List<String>> disabledSourcesForCategory(
          ExtensionCategory category) =>
      category.when(
        video: () => disabledVideoSources(),
        manga: () => disabledMangaSources(),
        novel: () => disabledNovelSources(),
      );

  Preference<List<String>> disabledVideoSources() =>
      _store.getStringList('hidden_video_catalogues', []);

  Preference<List<String>> disabledMangaSources() =>
      _store.getStringList('hidden_manga_catalogues', []);

  Preference<List<String>> disabledNovelSources() =>
      _store.getStringList('hidden_novel_catalogues', []);

  Preference<List<String>> pinnedSourcesForCategory(
          ExtensionCategory category) =>
      category.when(
        video: () => pinnedVideoSources(),
        manga: () => pinnedMangaSources(),
        novel: () => pinnedNovelSources(),
      );

  Preference<List<String>> pinnedVideoSources() =>
      _store.getStringList(Preference.appStateKey('pinned_video_sources'), []);

  Preference<List<String>> pinnedMangaSources() =>
      _store.getStringList(Preference.appStateKey('pinned_manga_sources'), []);

  Preference<List<String>> pinnedNovelSources() =>
      _store.getStringList(Preference.appStateKey('pinned_novel_sources'), []);

  Preference<int> lastUsedSourceByCategory(ExtensionCategory category) =>
      category.when(
        video: () => lastUsedVideoSource(),
        manga: () => lastUsedMangaSource(),
        novel: () => lastUsedNovelSource(),
      );

  Preference<ExtensionCategory> lastUsedExtensionCategory() => _store.getEnum(
        Preference.appStateKey('last_used_extension_category'),
        ExtensionCategory.video,
        ExtensionCategory.values,
      );

  Preference<int> lastUsedVideoSource() =>
      _store.getInt(Preference.appStateKey('last_used_video_source'), -1);

  Preference<int> lastUsedMangaSource() =>
      _store.getInt(Preference.appStateKey('last_used_manga_source'), -1);

  Preference<int> lastUsedNovelSource() =>
      _store.getInt(Preference.appStateKey('last_used_novel_source'), -1);

  Preference<int> extensionUpdatesCountByCategory(ExtensionCategory category) =>
      category.when(
        video: () => videoExtensionUpdatesCount(),
        manga: () => mangaExtensionUpdatesCount(),
        novel: () => novelExtensionUpdatesCount(),
      );

  Preference<int> videoExtensionUpdatesCount() =>
      _store.getInt(Preference.appStateKey('videoexts_updates_count'), 0);

  Preference<int> mangaExtensionUpdatesCount() =>
      _store.getInt(Preference.appStateKey('mangaexts_updates_count'), 0);

  Preference<int> novelExtensionUpdatesCount() =>
      _store.getInt(Preference.appStateKey('novelexts_updates_count'), 0);
}
