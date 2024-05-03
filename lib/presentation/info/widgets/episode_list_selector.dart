import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
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

  static const double height = 50;

  static const borderRadius = BorderRadius.all(Radius.circular(15));

  static const buttonPadding =
      MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10));

  static const selectorPadding = EdgeInsets.only(left: 10, bottom: 10);

  static const textStyle = TextStyle(fontWeight: FontWeight.bold);

  late final ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    if (!isMobile) {
      _controller = ScrollController();
    } else {
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final episodesKeyAndIndexes = InjectKtor.get<EpisodeListSelectorCubit>()
        .episodesKeyAndIndexes
        .entries;

    return InjecktorBlocBuilder<EpisodeListSelectorCubit, Pair<int, int>>(
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
    if (isMobile) return child;
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
        InjectKtor.get<EpisodeListSelectorCubit>().select(entry.value);
  
      },
      child: Text(entry.key, style: textStyle),
    );
  }
  // return Material(
  //   color: color,
  //   animationDuration: animationDuration,
  //   borderRadius: borderRadius,
  //   child: InkWell(
  //     splashColor: context.theme.colorScheme.primary,
  //     borderRadius: borderRadius,
  //     onTap: () {
  //       if (isNotSelected) {
  //         InjectKtor.get<EpisodeListSelectorCubit>().select(entry.value);
  //       }
  //     },
  //     child: Container(
  //       alignment: Alignment.center,
  //       padding: buttonPadding,
  //       decoration: BoxDecoration(
  //         borderRadius: borderRadius,
  //         border: Border.all(color: boderColor, width: 2),
  //       ),
  //       child: Text(entry.key, style: textStyle),
  //     ),
  //   ),
  // );
}
