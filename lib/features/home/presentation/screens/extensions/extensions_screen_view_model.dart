import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/helper/locale_helper.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/extension_list.dart';
import 'package:meiyou/shared/domain/models/install_step.dart';
import 'package:meiyou/shared/domain/extension_manager/extension_manger.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionsScreenViewModel {
  ExtensionsScreenViewModel({
    required ExtensionCategory category,
    required ExtensionManager extensionManger,
  })  : _category = category,
        _extensionManager = extensionManger,
        searchController = TextEditingController(text: '') {
    extensionManger.getExtensionList(category).let((it) {
      _extensionList = it.state;

      stateListenable =
          StateNotifier(!_extensionList.isInitialized && _extensionList.isEmpty
              ? const ExtensionsStateLoading()
              : _mapper(
                  searchController.text,
                  _extensionList,
                ));
      _streamSubscription = it.listen((data) {
        _extensionList = data;

        stateListenable
            .setState(_mapper(searchController.text, _extensionList));
      });
      searchController.addListener(() {
        stateListenable
            .setState(_mapper(searchController.text, _extensionList));
      });
    });
  }

  final ExtensionCategory _category;

  final ExtensionManager _extensionManager;

  final TextEditingController searchController;

  late ExtensionList _extensionList;

  late final StateNotifier<ExtensionsState> stateListenable;

  late final StreamSubscription<ExtensionList> _streamSubscription;

  final StateNotifier<Map<String, InstallStep>> downloadsStateListenable =
      StateNotifier({});

  InstallStep getDownloadStatus(Extension extension) {
    return downloadsStateListenable.state[extension.pkgName] ??
        InstallStep.idle;
  }

  ExtensionsState _mapper(String query, ExtensionList list) {
    final state = <String, List<Extension>>{};

    list.updates.where((e) => _queryfilter(query, e)).toList().let((it) {
      if (it.isNotEmpty) {
        state['Updates pending'] = it;
      }
    });
    list.installed.where((e) => _queryfilter(query, e)).toList().let((it) {
      if (it.isNotEmpty) {
        state['Installed'] = it;
      }
    });

    state.addAll(SplayTreeMap<String, List<AvailableExtension>>.from(
        list.available
            .where((e) => _queryfilter(query, e))
            .groupListsBy((ext) => ext.lang),
        (a, b) => LocaleHelper.comparator(a, b)));

    return ExtensionsStateData(state);
  }

  bool _queryfilter(String query, Extension extension) {
    if (query.isEmpty) return true;
    return query.split(',').any((input) {
      input = input.trim().toLowerCase();
      if (input.isEmpty) return false;
      if (extension is AvailableExtension) {
        return extension.sources.any((source) {
              return source.name.toLowerCase().contains(input) ||
                  (source.baseUrl?.contains(input) ?? false) ||
                  source.id == input.toIntOrNull();
            }) ||
            extension.name.contains(input);
      } else {
        return extension.sources.any((source) {
          return source.name.toLowerCase().contains(input) ||
              source.id == input.toIntOrNull() ||
              (source is HttpSource &&
                  source.baseUrl.toLowerCase().contains(input)) ||
              extension.name.contains(input);
        });
      }
    });
  }

  void _updateDownloadStatus(Extension extension, InstallStep installStep) {
    downloadsStateListenable.setState(Map.from(downloadsStateListenable.state)
      ..[extension.pkgName] = installStep);
  }

  void _removeDownloadStatus(Extension extension) {
    downloadsStateListenable.setState(
        Map.from(downloadsStateListenable.state)..remove(extension.pkgName));
  }

  void _addToDownload(Extension extension, Stream<InstallStep> stream) {
    final streamSubscription =
        stream.listen((event) => _updateDownloadStatus(extension, event));
    streamSubscription.onDone(() {
      _removeDownloadStatus(extension);
      streamSubscription.cancel();
    });
  }

  void installExtension(AvailableExtension extension) {
    return _addToDownload(
      extension,
      _extensionManager.installExtension(_category, extension),
    );
  }

  void cancelDownload(AvailableExtension extension) {
    _extensionManager.cancelDownload(_category, extension);
  }

  void updateExtension(InstalledExtension extension) {
    return _addToDownload(
      extension,
      _extensionManager.updateExtension(_category, extension),
    );
  }

  void uninstallExtension(InstalledExtension extension) {
    _extensionManager.uninstallExtension(_category, extension);
  }

  void dispose() {
    _streamSubscription.cancel();
    searchController.dispose();
    stateListenable.dispose();
  }
}

sealed class ExtensionsState {
  final Map<String, List<Extension>> extensions;

  const ExtensionsState(this.extensions);
}

class ExtensionsStateData extends ExtensionsState {
  const ExtensionsStateData(super.extensions);
}

class ExtensionsStateLoading extends ExtensionsState {
  const ExtensionsStateLoading() : super(const {});
}
