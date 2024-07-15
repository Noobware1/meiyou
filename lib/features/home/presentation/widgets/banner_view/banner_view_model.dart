import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/features/home/domain/models/home_paging_source.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source_view_model.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/src/result.dart';

class BannerViewModel
    extends PagingSourceViewModel<List<MediaPreview>, LoadHomePageParams> {
  @override
  final HomeBannerPagingSource pagingSource;
  final PageController pageController;
  final void Function(MediaPreview) _onSelected;
  final void Function(MediaPreview) _onAddToLibrary;

  BannerViewModel({
    required HomePagingSource homePagingSource,
    required void Function(MediaPreview) onSelected,
    required void Function(MediaPreview) onAddToLibrary,
  })  : pagingSource = HomeBannerPagingSource(pagingSource: homePagingSource),
        pageController = PageController(),
        _onSelected = onSelected,
        _onAddToLibrary = onAddToLibrary,
        super([]) {
    setState(pagingSource.value);
    pageController.addListener(() => onScrollEnd(pageController));
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (pageNotifer.state != page) {
        pageNotifer.setState(page);
      }
    });
  }

  @override
  bool loadMore(List<MediaPreview> value) => pagingSource.hasNextPage;

  late final StateNotifier<int> pageNotifer = StateNotifier<int>(0);

  Future<void> moveNext() {
    return pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> movePrevious() {
    return pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> onBannerTapDown(TapDownDetails details, double width) {
    if (details.globalPosition.dx < width / 2) {
      return movePrevious();
    } else {
      return moveNext();
    }
  }

  void onSelected() async {
    final selected = state[pageNotifer.state];
    _onSelected(selected);
  }

  Future<void> onAddToLibrary() async {
    final selected = state[pageNotifer.state];
    _onAddToLibrary(selected);
  }
}

class HomeBannerPagingSource
    extends PagingSource<List<MediaPreview>, LoadHomePageParams> {
  final HomePagingSource pagingSource;
  bool hasNextPage;
  HomeBannerPagingSource({
    required this.pagingSource,
  })  : hasNextPage = pagingSource.value.hasNextPage,
        super(
          value: pagingSource.value.toPreviewList(),
          params: pagingSource.params,
        );

  @override
  Future<Result<List<MediaPreview>>> load(LoadHomePageParams parmas) {
    return pagingSource.load(parmas).then((result) {
      hasNextPage = result.getOrNull()?.hasNextPage ?? false;
      return result.mapCatching(
        (value) => value.toPreviewList(),
      );
    });
  }

  @override
  LoadHomePageParams loadParams(LoadHomePageParams parmas) {
    return LoadHomePageParams(
      page: parmas.page + 1,
      request: parmas.request,
      hasNextPage: parmas.hasNextPage,
    );
  }

  @override
  List<MediaPreview> map(List<MediaPreview> a, List<MediaPreview> b) {
    return a + b;
  }
}

extension on HomePage {
  List<MediaPreview> toPreviewList() {
    return items.map((e) => e.list).flattened.toList();
  }
}
