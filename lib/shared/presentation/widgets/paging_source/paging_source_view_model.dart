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
        _load();
      }
    }
  }

  bool loadMore(Value value);

  late Params _newParams = pagingSource.params;

  void load(Params params) {
    pagingSource.load(_newParams).then((result) {
      result.when(
        success: (value) {
          setState(value);
        },
        failure: (error) {
          logger.warning('LoadError', error, StackTrace.current);
        },
      );
    });
  }

  void _load() {
    _newParams = pagingSource.loadParams(state, _newParams);
    load(_newParams);
  }
}
