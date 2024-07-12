import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

typedef CollaspeListener = void Function((bool isCollapsed, double percentage));

class _Delegate extends SliverPersistentHeaderDelegate {
  final PageController pageController;
  final SwitchableItem firstItem;
  final SwitchableItem secondItem;
  @override
  final double maxExtent;

  @override
  final double minExtent;

  _Delegate({
    required double safePadding,
    required this.firstItem,
    required this.secondItem,
    required this.pageController,
  })  : maxExtent = firstItem.height,
        minExtent = secondItem.height + safePadding;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final width = context.width;
    return SizedBox(
      height: firstItem.height,
      width: width,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        itemCount: 2,
        itemBuilder: (context, index) {
          return index == 0
              ? firstItem.builder(context)
              : Container(
                  height: firstItem.height,
                  width: width,
                  color: context.theme.scaffoldBackgroundColor,
                  alignment: Alignment.bottomCenter,
                  child: secondItem.builder(
                    context,
                  ),
                );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class AnimatedSliverHeader extends StatefulWidget {
  final ScrollController controller;
  final SwitchableItem firstItem;
  final SwitchableItem secondItem;
  final CollaspeListener collaspeListener;
  final double safePadding;

  const AnimatedSliverHeader({
    super.key,
    required this.controller,
    required this.firstItem,
    required this.secondItem,
    required this.collaspeListener,
    required this.safePadding,
  });

  @override
  State<AnimatedSliverHeader> createState() => _AnimatedSliverHeaderState();
}

final class SwitchableItem {
  final double height;
  final WidgetBuilder builder;

  SwitchableItem({required this.height, required this.builder});
}

class _AnimatedSliverHeaderState extends State<AnimatedSliverHeader> {
  bool isCollapsed = false;
  bool scrollToTop = false;
  static const percent = 45;
  late double mMaxScrollSize = widget.firstItem.height;
  double percentage = 0;
  late final PageController pageController;
  ScrollController get scrollController => widget.controller;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    widget.controller.addListener(scrollListener);
  }

  void scrollListener() {
    percentage = (scrollController.offset.abs() * 100) / mMaxScrollSize;
    if (percentage > 100) return;

    if (percentage >= percent && !isCollapsed) {
      isCollapsed = true;

      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }

    if (percentage <= percent && isCollapsed) {
      isCollapsed = false;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }

    widget.collaspeListener((isCollapsed, percentage));
  }

  @override
  void dispose() {
    widget.controller.removeListener(scrollListener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _Delegate(
        safePadding: widget.safePadding,
        firstItem: widget.firstItem,
        secondItem: widget.secondItem,
        pageController: pageController,
      ),
    );
  }
}
