import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'package:meiyou_extenstions/models.dart';
import 'image_holder.dart';

class ImageHolderListViewBuilder extends StatefulWidget {
  final double height;
  final double width;
  final void Function(SearchResponse selected)? onSelected;
  final HomePage homePage;
  final EdgeInsets padding;
  final ImageHolder Function(BuildContext context, SearchResponse data) builder;
  final String? label;
  final TextStyle? labelTextStyle;
  final EdgeInsets? labelPadding;
  final double spaceBetween;
  final double paddingAtStart;
  final double paddingAtEnd;
  final Alignment? labelAlignment;
  final TextStyle? textStyle;
  final double? labelBoxHeight;

  const ImageHolderListViewBuilder({
    super.key,
    required this.homePage,
    this.textStyle,
    this.onSelected,
    this.paddingAtStart = 0.0,
    this.paddingAtEnd = 0.0,
    this.padding = const EdgeInsets.only(left: 5, right: 5),
    this.spaceBetween = 6,
    required this.height,
    this.width = defaultPosterBoxWidth,
    required this.builder,
    this.label,
    this.labelTextStyle,
    this.labelPadding,
    this.labelBoxHeight,
    this.labelAlignment,
  });

  @override
  State<ImageHolderListViewBuilder> createState() =>
      _ImageHolderListViewBuilderState();
}

class _ImageHolderListViewBuilderState
    extends State<ImageHolderListViewBuilder> {
  int page = 1;
  late final ScrollController? _controller;

  @override
  void initState() {
    // _controller = ScrollController();
    _controller = null;
    // widget.homePage.data.data.addAll(widget.homePage.data.data);

    // if (widget.homePage.hasNextPage != null) {
    //   widget.controller.addListener(_listener);
    // }
    super.initState();
  }

  // void fetchMoreData(PluginManagerBloc pluginManagerBloc, int page) async {
  //   try {
  //     final data = await pluginManagerBloc.state.pluginManager!.loadHomePage(
  //       page,
  //       // pluginManagerBloc.state.pluginManager!.,

  //     );
  //     if (data != null) {
  //       list.addAll(data.metaResponses);
  //       setState(() {});
  //     }
  //   } catch (_) {}
  // }

  // void _listener() {
  //   if (widget.controller.position.pixels ==
  //       widget.controller.position.maxScrollExtent) {
  //     setState(() {
  //       page++;
  //       fetchMoreData(page);
  //     });
  //   }
  // }

  @override
  void deactivate() {
    // widget.controller.removeListener(_listener);

    super.deactivate();
  }

  @override
  void dispose() {
    // widget.controller.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget wrapWithLabel(Widget child) {
      if (widget.label != null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: widget.labelAlignment ?? Alignment.centerLeft,
              child: Padding(
                padding: widget.labelPadding ??
                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SizedBox(
                  height: widget.labelBoxHeight ?? 40,
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        decoration: BoxDecoration(
                            color: context.theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      addHorizontalSpace(10),
                      Text(widget.label!, style: widget.labelTextStyle),
                    ],
                  ),
                ),
              ),
            ),
            child
          ],
        );
      }
      return child;
    }

    return wrapWithLabel(
      Padding(
        padding: widget.padding,
        child: SizedBox(
          height: widget.height,
          width: context.screenWidth,
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            removeRight: true,
            child: ListView.builder(
                controller: _controller,
                itemCount: widget.homePage.data.data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(
                          left: (index == 0) ? widget.paddingAtStart : 0.0,
                          right: (index != widget.homePage.data.data.length - 1)
                              ? widget.spaceBetween
                              : 0),
                      child: ImageButtonWrapper(
                        onTap: () {
                          widget.onSelected
                              ?.call(widget.homePage.data.data[index]);
                        },
                        child: widget.builder(
                            context, widget.homePage.data.data[index]),
                      ));
                }),
          ),
        ),
      ),
    );
  }
}
