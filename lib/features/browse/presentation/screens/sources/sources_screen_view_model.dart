import 'dart:async';
import 'dart:collection';

import 'package:meiyou/core/helper/locale_helper.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_enabled_intalled_sources.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:nice_dart/nice_dart.dart';

class SourcesScreenViewModel {
  SourcesScreenViewModel({
    required SourcePreferences preferences,
    required getEnabledSourcesUseCase getEnabledSourcesUseCase,
    required ExtensionCategory category,
    required void Function(InstalledSource source) onSourceSelected,
  })  : _preferences = preferences,
        _category = category,
        _onSourceSelected = onSourceSelected {
    getEnabledSourcesUseCase(getEnabledSourcesUseCaseParams(category: category))
        .let((it) {
      stateListenable = StateNotifier(_mapper(it.state));
      _streamSubscription = it.listen((event) {
        stateListenable.setState(_mapper(event));
      }, onError: (error) {
        stateListenable.setState(
            SourcesStateError._(stateListenable.state.sources, error));
      });
    });
  }

  final SourcePreferences _preferences;

  final void Function(InstalledSource source) _onSourceSelected;

  final ExtensionCategory _category;

  late final StateNotifier<SourcesState> stateListenable;

  late final StreamSubscription<List<InstalledSource>> _streamSubscription;

  SourcesStateData _mapper(List<InstalledSource> sources) {
    var map = SplayTreeMap<String, List<InstalledSource>>((d1, d2) {
      if (d1 == LocaleHelper.lastUsedKey && d2 != LocaleHelper.lastUsedKey) {
        return -1;
      } else if (d2 == LocaleHelper.lastUsedKey &&
          d1 != LocaleHelper.lastUsedKey) {
        return 1;
      }
      if (d1 == LocaleHelper.pinnedKey && d2 != LocaleHelper.pinnedKey) {
        return -1;
      }
      if (d2 == LocaleHelper.pinnedKey && d1 != LocaleHelper.pinnedKey) {
        return 1;
      }
      if (d1.isEmpty && d2.isNotEmpty) return 1;
      if (d2.isEmpty && d1.isNotEmpty) return -1;
      return d1.compareTo(d2);
    });

    for (var source in sources) {
      String key;
      if (source.isUsedLast) {
        key = LocaleHelper.lastUsedKey;
      } else if (source.isPinned) {
        key = LocaleHelper.pinnedKey;
      } else {
        key = source.language;
      }
      map.putIfAbsent(key, () => []).add(source);
    }

    return SourcesStateData._(map);
  }

  void selectedSource(InstalledSource source) {
    _preferences.lastUsedSourceByCategory(_category).set(source.id);
    _preferences.lastUsedExtensionCategory().set(_category);
    _onSourceSelected(source);
  }

  void togglePin(InstalledSource source) {
    _preferences.pinnedSourcesForCategory(_category).let((it) {
      final id = '${source.id}';
      final pinned = it.get();
      if (pinned.contains(id)) {
        pinned.remove(id);
      } else {
        pinned.add(id);
      }

      it.set(pinned);
    });
  }

  void dispose() {
    _streamSubscription.cancel();
    stateListenable.dispose();
  }
}

sealed class SourcesState {
  final Map<String, List<InstalledSource>> sources;

  const SourcesState(this.sources);
}

class SourcesStateLoading extends SourcesState {
  SourcesStateLoading._() : super(const {});
}

class SourcesStateError extends SourcesState {
  final Object error;

  const SourcesStateError._(
      Map<String, List<InstalledSource>> sources, this.error)
      : super(sources);
}

class SourcesStateData extends SourcesState {
  const SourcesStateData._(Map<String, List<InstalledSource>> sources)
      : super(sources);
}
