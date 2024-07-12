import 'package:flutter/material.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:nice_dart/nice_dart.dart';

class EpisodeListSelector extends StatefulWidget {
  const EpisodeListSelector({
    super.key,
  });

  @override
  State<EpisodeListSelector> createState() => _EpisodeListSelectorState();
}

class _EpisodeListSelectorState extends State<EpisodeListSelector> {
  static const ScrollbarThemeData scrollbarTheme = ScrollbarThemeData(
    thumbColor: MaterialStatePropertyAll(Colors.grey),
  );

  static const HorizontalSpace space = HorizontalSpace(10);

  static const double height = 40;

  static const borderRadius = BorderRadius.all(Radius.circular(15));

  static const buttonPadding =
      MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10));

  static const selectorPadding = EdgeInsets.only(left: 10, bottom: 10);

  static const textStyle = TextStyle(fontWeight: FontWeight.bold);

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final episodesKeyAndIndexes =
        getIt.get<EpisodeListSelectorNotifer>().episodesKeyAndIndexes.entries;

    if (episodesKeyAndIndexes.length <= 1) {
      return const SizedBox();
    }

    return GetItListenableBuilder<EpisodeListSelectorNotifer, Pair<int, int>>(
      builder: (context, state) {
        return Padding(
          padding: selectorPadding,
          child: SizedBox(
            height: height,
            width: context.width,
            child: srollBar(
              child: episodeListSelection(
                  entries: episodesKeyAndIndexes, state: state),
            ),
          ),
        );
      },
    );
  }

  Widget srollBar({required Widget child}) {
    if (context.screenSize.isMobile) return child;
    return ScrollbarTheme(
      data: scrollbarTheme,
      child: Scrollbar(
        controller: _controller,
        child: child,
      ),
    );
  }

  Widget episodeListSelection(
      {required Iterable<MapEntry<String, Pair<int, int>>> entries,
      required Pair<int, int> state}) {
    return ListView.separated(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, i) => space,
      itemCount: entries.length,
      itemBuilder: (context, index) =>
          button(state: state, entry: entries.get(index)),
    );
  }

  Widget button({
    required Pair<int, int> state,
    required MapEntry<String, Pair<int, int>> entry,
  }) {
    final isNotSelected = state != entry.value;
    final color = isNotSelected
        ? context.theme.colorScheme.background
        : context.theme.colorScheme.primary;
    final boderColor =
        isNotSelected ? Colors.grey : context.theme.colorScheme.primary;
    return ElevatedButton(
      style: ButtonStyle(
        overlayColor:
            MaterialStatePropertyAll(context.theme.colorScheme.primary),
        padding: buttonPadding,
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(color: boderColor, width: 2),
          ),
        ),
      ),
      onPressed: () {
        getIt.get<EpisodeListSelectorNotifer>().select(entry.value);
      },
      child: Text(entry.key,
          style: textStyle.copyWith(
              color:
                  !isNotSelected ? context.theme.colorScheme.onPrimary : null)),
    );
  }
}
