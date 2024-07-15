import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source.dart';

abstract class PagingSourceViewModel<Value, Params>
    extends StateNotifier<Value> {
  abstract final PagingSource<Value, Params> pagingSource;

  PagingSourceViewModel(super.state);

  void onScrollEnd(ScrollController scrollController) {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      if (loadMore(state)) {
        load();
      }
    }
  }

  bool loadMore(Value value);

  void load() {
    pagingSource.load(pagingSource.params).then((result) {
      result.when(
        success: (value) {
          setState(state);
        },
        failure: (error) {
          logger.warning('LoadError', error, StackTrace.current);
        },
      );
    });
  }
}
