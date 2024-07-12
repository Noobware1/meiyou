import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/data/extension/extension_manager_impl.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/extension_manager/extension_manger.dart';
import 'package:meiyou/shared/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:collection/collection.dart';
import 'package:nice_dart/nice_dart.dart';

class SourceManagerImpl implements SourceManager {
  SourceManagerImpl(
      {required SourcePreferences sourcePreferences,
      required ExtensionManager manager})
      : _sourcePreferences = sourcePreferences,
        _manager = manager {
    ExtensionCategory.values.forEachIndexed((index, category) {
      _sourceStreamMap[index] = _manager
          .getInstalledExtensionsStream(category)
          .let((it) => StateStream.fromStream(
                it.map((event) => event.toSourcesMap(category)),
                initialData: it.state.toSourcesMap(category),
              ));

      _catatgogueSources[index] = _sourceStreamMap[index]!
          .map((event) => event.values.whereType<CatalogueSource>().toList());
    });
  }

  final SourcePreferences _sourcePreferences;
  final ExtensionManager _manager;

  final List<StateStream<Map<int, Source>>?> _sourceStreamMap =
      List.filled(3, null);

  final List<StateStream<List<CatalogueSource>>?> _catatgogueSources =
      List.filled(3, null);

  @override
  Source? getSource(int id, ExtensionCategory category) {
    return _sourceStreamMap[category.index]!.state[id];
  }

  @override
  StateStream<List<CatalogueSource>> getCatalogueSources(
          ExtensionCategory category) =>
      _catatgogueSources[category.index]!;
}

extension on List<InstalledExtension> {
  Map<int, Source> toSourcesMap(ExtensionCategory category) {
    return Map.fromIterable(map((e) => e.sources.map((e) => e)).flattened,
        key: (e) => (e as Source).id);
  }
}
