import 'package:flutter/material.dart';

import 'package:isar/isar.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/database/database.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/library/models/library_item.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LibraryRepository {
  LibraryRepository(this.dataBase, this.sourceManager);

  final DataBase dataBase;
  final SourceManager sourceManager;

  Stream<List<LibraryItem>> getLibraryForType(ExtensionType type) {
    return dataBase.library
        .filter()
        .typeEqualTo(type)
        .watch(fireImmediately: true);
  }

  Future<void> addToLibary(LibraryItem item) {
    return dataBase.addToLibary(item);
  }

  Future<void> updateLibaryItem(LibraryItem item) {
    return dataBase.updateLibaryItem(item);
  }

  Future<void> removeFromLibrary(LibraryItem item) {
    return dataBase.removeFromLibrary(item);
  }

  void goToInfoScreen(BuildContext context, LibraryItem item) {
    final source = sourceManager.getSource(item.type, item.sourceId);
    getIt.get<SelectedSource>().forceEmit(item.type, source);
    context.goToInfoScreen(item.toContentItem());
  }

  LibraryItem? getFromLibrary(Source source, ExtensionType type, String name) {
    return dataBase.library
        .filter()
        .typeEqualTo(type)
        .sourceIdEqualTo(source.id)
        .titleEqualTo(name)
        .findFirstSync();
  }
}
