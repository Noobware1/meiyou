import 'package:flutter/material.dart';
import 'package:nice_dart/nice_dart.dart';

class ResizableTabBar extends StatefulWidget {
  final List<Widget> children;
  final List<Tab> tabs;
  final Duration animationDuration;

  const ResizableTabBar({
    super.key,
    required this.children,
    required this.tabs,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ResizableTabBar> createState() => ResizableTabBarState();
}

class ResizableTabBarState<T extends ResizableTabBar> extends State<T>
    with SingleTickerProviderStateMixin {
  late final List<GlobalKey> keys;
  late final List<Size> sizes;
  late final TabController tabController;

  bool calculatingSize = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    final len = widget.children.length;
    keys = List.generate(len, (index) => GlobalKey());
    sizes = List.filled(len, Size.zero);
    tabController = TabController(
      length: len,
      vsync: this,
    )..addListener(listener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        for (int i = 0; i < len; i++) {
          sizes[i] = keys[i].currentContext?.size ?? Size.zero;
        }
        calculatingSize = false;
        keys.clear();
      });
    });
  }

  void listener() {
    if (index == tabController.index) {
      return;
    }
    setState(() {
      index = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.removeListener(listener);
    tabController.dispose();
    super.dispose();
  }

  List<Widget> children() {
    return [
      tabBar(),
      tabBarView(),
    ];
  }

  Widget tabBar() {
    return TabBar(
      tabs: widget.tabs,
      controller: tabController,
    );
  }

  Widget tabBarView() {
    return Flexible(
      child: AnimatedContainer(
        duration: widget.animationDuration,
        height: sizes[index].height,
        width: sizes[index].width,
        child: TabBarView(controller: tabController, children: widget.children),
      ),
    );
  }

  Widget calculatingWidget() {
    return Visibility.maintain(
      visible: false,
      child: SingleChildScrollView(
        child: Column(
          children: widget.children.mapListIndexed(
            (index, child) => Container(
              key: keys[index],
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !calculatingSize
        ? Column(mainAxisSize: MainAxisSize.min, children: children())
        : calculatingWidget();
  }
}
