import 'package:meiyou/core/utils/extensions/iterable.dart';

import 'package:meiyou/core/utils/resources/combine_stream.dart';
import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/core/utils/resources/locale_helper.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/domain/models/source.dart' hide Source;
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:collection/collection.dart';
import 'package:nice_dart/nice_dart.dart';

typedef InstalledSources = Map<String, List<InstalledSource>>;

typedef AvailableSources = Map<String, List<AvailableExtension>>;

class SourceManager {
  final SourcePreferences _sourcePreferences;
  final ExtensionManager _manager;

  SourceManager(
      {required SourcePreferences sourcePreferences,
      required ExtensionManager manager})
      : _sourcePreferences = sourcePreferences,
        _manager = manager;

  Stream<Source?> selectedSourceStream() {
    return CombineStream.combine4(
      _sourcePreferences.lastUsedExtensionType().changes(),
      _sourcePreferences.lastUsedVideoSource().changes(),
      _sourcePreferences.lastUsedMangaSource().changes(),
      _sourcePreferences.lastUsedNovelSource().changes(),
      initalDataA: _sourcePreferences.lastUsedExtensionType().get(),
      initalDataB: _sourcePreferences.lastUsedVideoSource().get(),
      initalDataC: _sourcePreferences.lastUsedMangaSource().get(),
      initalDataD: _sourcePreferences.lastUsedNovelSource().get(),
      (type, videoSource, mangaSource, novelSource) {
        return type.when(
          video: () => getSource(type, videoSource),
          manga: () => getSource(type, mangaSource),
          novel: () => getSource(type, novelSource),
        );
      },
    );
  }

  Source? getCurrentSource() {
    return getSource(ExtensionType.Manga, -1);
  }

  Source? getSource(ExtensionType type, int id) {
    if (id == -1) return null;
    return _manager
        .getInstalledExtensionsFlow(type)
        .state
        .find((ext) => ext.sources.any((it) => it.id == id))
        ?.sources
        .firstWhere((it) => it.id == id);
  }

  StateFlow<InstalledSources> getInstalledSourcesFlow(ExtensionType type) {
    return _manager.getInstalledExtensionsFlow(type).let((it) =>
        StateFlow.stream(
            _installedSourcesMap(
                _sourcePreferences.enabledLanguages().get(),
                _sourcePreferences.lastUsedSourceByType(type).get(),
                it.state.toInstalledSourcesList(type)),
            CombineStream.combine3(
              _sourcePreferences.enabledLanguages().changes(),
              _sourcePreferences.lastUsedSourceByType(type).changes(),
              it.stream,
              (langs, lastUsedSource, exts) => _installedSourcesMap(
                  langs, lastUsedSource, exts.toInstalledSourcesList(type)),
              initalDataA: _sourcePreferences.enabledLanguages().get(),
              initalDataB: _sourcePreferences.lastUsedSourceByType(type).get(),
              initalDataC: it.state,
            )));
  }

  static Map<String, List<InstalledSource>> _installedSourcesMap(
      List<String> enabledLanguages,
      int lastUsedSource,
      List<InstalledSource> extensions) {
    final lastUsed = lastUsedSource == -1
        ? null
        : extensions.firstWhereOrNull((e) => e.id == lastUsedSource);

    if (lastUsed != null) {
      extensions.remove(lastUsed);
    }

    return extensions
        .where((ext) => enabledLanguages.any((element) => element == ext.lang))
        .groupListsBy((element) => element.lang)
        .map((lang, exts) =>
            MapEntry(LocaleHelper.getSourceDisplayName(lang), exts))
        .let((it) {
      if (lastUsed == null) return it;
      return {
        'Last Used': [lastUsed]
      }..addAll(it);
    });
  }

  StateFlow<AvailableSources> getAvaiableSourcesFlow(ExtensionType type) {
    return StateFlow.stream(
        _availableSourcesMap(
          _sourcePreferences.enabledLanguages().get(),
          _manager.getInstalledExtensionsFlow(type).state,
          _manager.getAvailableExtensionsFlow(type).state,
        ),
        CombineStream.combine3(
          _sourcePreferences.enabledLanguages().changes(),
          _manager.getInstalledExtensionsFlow(type).stream,
          _manager.getAvailableExtensionsFlow(type).stream,
          _availableSourcesMap,
          initalDataA: _sourcePreferences.enabledLanguages().get(),
          initalDataB: _manager.getInstalledExtensionsFlow(type).state,
          initalDataC: _manager.getAvailableExtensionsFlow(type).state,
        ));
  }

  static AvailableSources _availableSourcesMap(List<String> enabledLanguages,
      List<InstalledExtension> installed, List<AvailableExtension> available) {
    return available
        .where((ext) => !installed.any((it) =>
            it.pkgName == ext.pkgName &&
            enabledLanguages.any((element) => element == ext.lang)))
        .groupListsBy((element) => element.lang)
        .map((lang, exts) =>
            MapEntry(LocaleHelper.getSourceDisplayName(lang), exts));
  }
}

extension on Source {
  InstalledSource toInstalledSource(ExtensionType type) {
    return InstalledSource.fromSource(type, this);
  }
}

extension on List<InstalledExtension> {
  List<InstalledSource> toInstalledSourcesList(ExtensionType type) {
    return map((e) => e.sources.map((e) => e.toInstalledSource(type)))
        .flattened
        .toList();
  }
}
