import 'package:flutter/material.dart';
import 'package:meiyou/features/home/domain/models/home_paging_source.dart';
import 'package:meiyou/features/home/presentation/widgets/home_row/home_row_view_model.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source_view_model.dart';
import 'package:meiyou/shared/presentation/widgets/poster_view/poster_view.dart';
import 'package:meiyou_extensions_lib/models.dart';

class HomeRow extends StatefulWidget {
  final HomePagingSource homePagingSource;
  final void Function(MediaPreview) onSelected;
  final void Function(MediaPreview) onAddToLibrary;
  const HomeRow({
    super.key,
    required this.homePagingSource,
    required this.onSelected,
    required this.onAddToLibrary,
  });

  @override
  State<HomeRow> createState() => _HomeRowState();
}

class _HomeRowState extends State<HomeRow>
    with PagingSourceStateMixin<HomePage, LoadHomePageParams, HomeRow> {
  @override
  HomeRowViewModel get viewModel => super.viewModel as HomeRowViewModel;

  @override
  Widget build(BuildContext context) {
    final items = pageState.items;
    return Column(
        children: List.generate(items.length, (index) {
      final item = items[index];
      final controller = viewModel.getScrollController(index);
      return PosterView(
        label: item.title,
        onSelected: viewModel.onSelected,
        onLongPressed: viewModel.onAddToLibrary,
        scrollController: controller,
        previews: item.list,
      );
    }));
  }

  @override
  HomeRowViewModel createViewModel() => HomeRowViewModel(
        homePagingSource: widget.homePagingSource,
        onSelected: widget.onSelected,
        onAddToLibrary: widget.onAddToLibrary,
      );
}
