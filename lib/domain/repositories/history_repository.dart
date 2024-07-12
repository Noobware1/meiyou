import 'dart:async';

import 'package:isar/isar.dart';
import 'package:meiyou/core/database/database.dart';
import 'package:meiyou/domain/models/history.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/domain/models/progress_type.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HistoryRepository {
  final DataBase dataBase;

  HistoryRepository(this.dataBase);

  Stream<List<History>> get getVideoHistory => dataBase.history
      .filter()
      .typeEqualTo(ExtensionType.Video)
      .sortByLastSeenDesc()
      .watch(fireImmediately: true)
      .asBroadcastStream();

  Stream<List<History>> get getMangaHistory => dataBase.history
      .filter()
      .typeEqualTo(ExtensionType.Manga)
      .sortByLastSeenDesc()
      .watch(fireImmediately: true)
      .asBroadcastStream();

  Stream<List<History>> get getNovelHistory => dataBase.history
      .filter()
      .typeEqualTo(ExtensionType.Novel)
      .sortByLastSeenDesc()
      .watch(fireImmediately: true)
      .asBroadcastStream();

  void updateHistory(History history) {
    dataBase.updateHistory(history);
  }

  History? getFromHistory(ExtensionType type, int sourceId, String title) {
    return dataBase.history
        .filter()
        .typeEqualTo(type)
        .sourceIdEqualTo(sourceId)
        .titleEqualTo(title)
        .findFirstSync();
  }

  Future<void> deleteHistory(History history) {
    return dataBase.deleteHistory(history);
  }

  Future<void> deleteAll(ExtensionType type) {
    return dataBase.deleteAll(type);
  }

  Stream<HomePage> getContinue(int sourceId, ExtensionType type) {
    return dataBase.history
        .filter()
        .typeEqualTo(type)
        .watch(fireImmediately: true)
        .transform(StreamTransformer.fromHandlers(handleData: (data, sink) {
      final items = data
          .where((element) => element.sourceId == sourceId)
          .mapList((e) => e.toContentItem());
      sink.add(HomePage.of(
          name: type == ExtensionType.Video
              ? 'Continue Watching'
              : 'Continue Reading',
          items: items,
          hasNextPage: false));
    }));
  }
}
