import 'package:flutter/material.dart';
import 'package:meiyou/features/home/domain/models/home_paging_source.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source_view_model.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/src/result.dart';

class HomeRowViewModel
    extends PagingSourceViewModel<HomePage, LoadHomePageParams> {
  final HomePagingSource _homePagingSource;
  final List<ScrollController> _scrollControllers;
  final void Function(MediaPreview) _onSelected;
  final void Function(MediaPreview) _onAddToLibrary;

  HomeRowViewModel(
      {required HomePagingSource homePagingSource,
      required void Function(MediaPreview) onSelected,
      required void Function(MediaPreview) onAddToLibrary})
      : _homePagingSource = homePagingSource,
        _scrollControllers = List.generate(
          homePagingSource.value.items.length,
          (_) => ScrollController(),
          growable: false,
        ),
        _onSelected = onSelected,
        _onAddToLibrary = onAddToLibrary,
        super(homePagingSource.value) {
    for (var controller in _scrollControllers) {
      controller.addListener(() => onScrollEnd(controller));
    }
  }

  @override
  bool loadMore(HomePage value) => value.hasNextPage;

  @override
  PagingSource<HomePage, LoadHomePageParams> get pagingSource =>
      _homePagingSource;

  ScrollController getScrollController(int index) {
    return _scrollControllers[index];
  }

  void onSelected(MediaPreview preview) {
    return _onSelected(preview);
  }

  void onAddToLibrary(MediaPreview preview) {
    return _onAddToLibrary(preview);
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
