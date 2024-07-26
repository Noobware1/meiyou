import 'package:flutter/material.dart';
import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/features/home/presentation/widgets/home_row/home_row_view_model.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/poster_view/poster_view.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

class HomeRow extends StatefulWidget {
  final StateNotifier<ExpandedHomePageList> listenable;
  final void Function(Media) onPressed;
  final void Function(Media) onLongPressed;
  final void Function(String) onScrollEnd;

  const HomeRow({
    super.key,
    required this.listenable,
    required this.onPressed,
    required this.onLongPressed,
    required this.onScrollEnd,
  });

  @override
  State<HomeRow> createState() => _HomeRowState();
}

class _HomeRowState extends State<HomeRow> {
  late final HomeRowViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeRowViewModel(
      listenable: widget.listenable,
      onPressed: widget.onPressed,
      onLongPressed: widget.onLongPressed,
      onScrollEnd: widget.onScrollEnd,
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
      stateListenable: viewModel.listenable,
      builder: (context, state, _) {
        return PosterView(
          label: state.title,
          onSelected: viewModel.onPressed,
          onLongPressed: viewModel.onLongPressed,
          scrollController: viewModel.scrollController,
          mediaList: state.mediaList,
        );
      },
    );
  }
}
