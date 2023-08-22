import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChangeHeaderOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final Widget firstChild;
  final Widget secondChild;
  final double height;
  const ChangeHeaderOnScroll(
      {super.key,
      required this.height,
      required this.scrollController,
      required this.firstChild,
      required this.secondChild});

  @override
  State<ChangeHeaderOnScroll> createState() => _ChangeHeaderOnScrollState();
}

class _ChangeHeaderOnScrollState extends State<ChangeHeaderOnScroll> {
  bool shouldScroll = false;
  bool changeHeaders = false;
  bool stick = false;
  bool isLocked = false;
  double height = 0.0;
  // double height = 100;
  @override
  void initState() {
    height = widget.height;
    // controller =
    //     ScrollAnimationController.fromScrollController(widget.scrollController);
    widget.scrollController.addListener(_listener);
    super.initState();
  }

  void _listener() {
    // final value = controller.value;
    if (widget.scrollController.offset > 180) {
      // controller.updateHeightAndHeader(100, true);
      setState(() {
        changeHeaders = true;
      });
      if (widget.scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          !isLocked) {
        // controller.updateHeightAndLock(100, true);
        setState(() {
          isLocked = true;
        });
      }
    } else {
      setState(() {
        // height = 200;
        changeHeaders = false;
        isLocked = false;
      });
    }

    // if (!changeHeaders &&
    //     widget.scrollController.position.userScrollDirection ==
    //         ScrollDirection.forward) {
    //   widget.scrollController.animateTo(0.0,
    //       duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    // }

    // if (widget.scrollController.position.userScrollDirection ==
    //         ScrollDirection.reverse &&
    //     widget.scrollController.offset > 0.0) {
    //   Future.delayed(const Duration(milliseconds: 50), () {
    //     return widget.scrollController.position.isScrollingNotifier.value;
    //   }).then((value) {
    //     if (value == false && widget.scrollController.offset < 180) {
    //       widget.scrollController.animateTo(0.0,
    //           duration: const Duration(milliseconds: 200),
    //           curve: Curves.easeIn);
    //     }
    //   });
    // }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: stick,
      delegate: _StickyHeader(
        height: changeHeaders ? 330 : 400,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            final inAnimation =
                Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                    .animate(animation);

            final outAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation);

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                if (inAnimation.isCompleted && isLocked) {
                  stick = true;
                  shouldScroll = true;
                  // height = 100;
                  //          physics = null;
                } else {
                  stick = false;
                  // height = widget.height;
                  shouldScroll = false;
                  //        physics = null;
                }
              });
            });

            return SlideTransition(
              position: animation.status == AnimationStatus.forward
                  ? inAnimation
                  : outAnimation,
              child: Align(alignment: Alignment.topCenter, child: child),
            );
          },
          child: changeHeaders ? widget.secondChild : widget.firstChild,
        ),
      ),
    );
  }
}

class _StickyHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _StickyHeader({required this.child, required this.height});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
