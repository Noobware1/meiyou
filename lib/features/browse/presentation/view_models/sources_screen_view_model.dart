import 'dart:async';
import 'dart:collection';

import 'package:meiyou/core/helper/locale_helper.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_enabled_intalled_sources.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:nice_dart/nice_dart.dart';

class SourcesScreenViewModel {
  SourcesScreenViewModel({
    required getEnabledSourcesUseCase getEnabledSourcesUseCase,
    required ExtensionCategory category,
  }) {
    getEnabledSourcesUseCase(getEnabledSourcesUseCaseParams(category: category))
        .let((it) {
      stateListenable = StateNotifier(_mapper(it.state));
      _streamSubscription = it.listen((event) {
        stateListenable.setState(_mapper(event));
      });
    });
  }

  late final StateNotifier<Map<String, List<InstalledSource>>> stateListenable;

  late final StreamSubscription<List<InstalledSource>> _streamSubscription;

  Map<String, List<InstalledSource>> _mapper(List<InstalledSource> sources) {
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

    return map;
  }

  void dispose() {
    _streamSubscription.cancel();
    stateListenable.dispose();
  }
}
