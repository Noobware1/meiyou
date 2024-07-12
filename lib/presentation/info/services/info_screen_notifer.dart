import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/domain/progress/progress_repository.dart';
import 'package:meiyou/domain/repositories/history_repository.dart';
import 'package:meiyou/domain/library/library_repository.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

extension GetContentProgress on InfoPage {
  ContentProgress? getContentProgress() {
    if (content == null || content!.isLazy) return null;
    final selectedSource = getIt.get<SelectedSource>();

    final progress = getIt.get<ProgressRepository>().getContentProgress(
          selectedSource.source!.id,
          selectedSource.type,
          name,
          content!,
        );

    return progress;
  }
}

class InfoScreenNotifer extends AsyncStateNotifier<InfoPage> {
  final ContentItem _contentItem;
  InfoScreenNotifer(
    this._contentItem,
  ) : super.loading() {
    _load();
  }

  void _load() {
    return setFuture(() => getIt
        .get<SourceRepository>()
        .getInfoPage(getIt.get<SelectedSource>().source!, _contentItem)
        .then((value) => value.getOrThrow()));
  }

  void retry() => _load();

  void addContent(Content content) {
    assert(state.hasValue);
    setData(state.asData!.value.copyWith(content: content));
  }
}
