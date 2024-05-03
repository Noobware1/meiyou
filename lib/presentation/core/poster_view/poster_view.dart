import 'package:flutter/material.dart';

class PosterView extends StatefulWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final double? padding;
  final VoidCallback? onViewFinished;
  final double spacing;

  const PosterView({
    super.key,
    this.onViewFinished,
    required this.itemBuilder,
    required this.itemCount,
    this.spacing = 0.0,
    this.padding,
  });

  @override
  State<PosterView> createState() => _PosterViewState();
}

class _PosterViewState<T extends PosterView> extends State<T> {
  late int itemCount;
  late final ScrollController? controller;

  void listener() {
    if (controller?.position.pixels == controller?.position.maxScrollExtent) {
      widget.onViewFinished?.call();
    }
  }

  @override
  void initState() {
    itemCount = widget.itemCount;
    if (widget.onViewFinished != null) {
      controller = ScrollController()..addListener(listener);
    } else {
      controller = null;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount) {
      setState(() {
        itemCount = widget.itemCount;
      });
    }
  }

  @override
  void dispose() {
    controller?.removeListener(listener);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.separated(
      controller: controller,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index == 0 && widget.padding != null) {
          return Padding(
              padding: EdgeInsets.only(left: widget.padding!),
              child: widget.itemBuilder(context, index));
        }
        return widget.itemBuilder(context, index);
      },
      separatorBuilder: (context, index) => SizedBox(width: widget.spacing),
      itemCount: itemCount,
    );
  }
}
