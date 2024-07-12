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

typedef AvailableSources = Map<String, List<Extension>>;

class SourceManager {
  SourceManager(
      {required SourcePreferences sourcePreferences,
      required ExtensionManager manager})
      : _sourcePreferences = sourcePreferences,
        _manager = manager;

  final SourcePreferences _sourcePreferences;
  final ExtensionManager _manager;

  Stream<(ExtensionType, Source?)> selectedSourceStream() {
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
          video: () => (type, getSource(type, videoSource)),
          manga: () => (type, getSource(type, mangaSource)),
          novel: () => (type, getSource(type, novelSource)),
        );
      },
    );
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
