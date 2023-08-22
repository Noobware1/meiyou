import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/row.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'image_holder.dart';

class ImageListView extends StatefulWidget {
  final double height;
  final double width;
  final MetaRowEntity data;
  final EdgeInsets padding;
  final double spaceBetween;
  final double paddingAtStart;
  final double paddingAtEnd;
  final TextStyle? textStyle;
  final ScrollController controller;

  const ImageListView(
      {super.key,
      required this.data,
      this.textStyle,
      required this.controller,
      this.paddingAtStart = 0.0,
      this.paddingAtEnd = 0.0,
      this.padding = const EdgeInsets.only(left: 5, right: 5),
      this.spaceBetween = 8,
      this.height = defaultPosterBoxHeight,
      this.width = defaultPosterBoxWidth});

  @override
  State<ImageListView> createState() => _ImageListViewState();

  static Widget withLabel(
      {required BuildContext context,
      required ScrollController controller,
      required MetaRowEntity data,
      double paddingAtStart = 0.0,
      double paddingAtEnd = 0.0,
      EdgeInsets padding = const EdgeInsets.only(left: 5, right: 5),
      EdgeInsets labelPadding = const EdgeInsets.only(left: 10),
      double spaceBetween = 8,
      TextStyle? textStyle,
      double height = defaultPosterBoxHeight,
      double width = defaultPosterBoxWidth}) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: (height != defaultPosterBoxHeight ? height + 35 : height) + 42,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: labelPadding,
              child: SizedBox(
                height: 32,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                  child: Text(
                    data.rowTitle,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageListView(
              controller: controller,
              data: data,
              height: height,
              textStyle: textStyle,
              padding: padding,
              spaceBetween: spaceBetween,
              width: width,
              paddingAtStart: paddingAtStart,
              paddingAtEnd: paddingAtEnd,
            )
          ],
        ),
      ),
    );
  }

  static Widget withButtonAndLabel(
      {required BuildContext context,
      required ScrollController controller,
      required MetaRowEntity data,
      TextStyle? textStyle,
      double paddingAtStart = 0.0,
      double paddingAtEnd = 0.0,
      EdgeInsets padding = const EdgeInsets.only(left: 3, right: 3),
      double spaceBetween = 8,
      Future<List<MetaRowEntity>?> Function(int page)? fetchMoreData,
      double height = defaultPosterBoxHeight,
      double width = defaultPosterBoxWidth}) {
    const shape = CircleBorder();
    return Stack(
      children: [
        withLabel(
            labelPadding: const EdgeInsets.only(
              left: 40,
            ),
            controller: controller,
            context: context,
            data: data,
            textStyle: textStyle,
            paddingAtStart: paddingAtStart,
            paddingAtEnd: paddingAtEnd,
            width: width,
            height: height,
            padding: const EdgeInsets.only(left: 40, right: 40),
            spaceBetween: spaceBetween),
        Positioned(
          left: 0,
          top: 40,
          bottom: 35,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ArrowButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 40,
              ),
              onTap: () => controller.animateTo(
                  controller.position.pixels - 300,
                  duration: animationDuration,
                  curve: Curves.fastEaseInToSlowEaseOut),
              shape: shape,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 40,
          bottom: 35,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ArrowButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 40,
              ),
              shape: shape,
              onTap: () => controller.animateTo(
                  controller.position.pixels + 300,
                  duration: animationDuration,
                  curve: Curves.fastEaseInToSlowEaseOut),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageListViewState extends State<ImageListView> {
  final list = <MetaResponseEntity>[];
  int page = 1;
  // late final ScrollController _controller;
//
  @override
  void initState() {
    list.addAll(widget.data.resultsEntity.metaResponses);

    // _controller = ScrollController();
    if (widget.data.loadMoreData != null) {
      widget.controller.addListener(_listener);
    }
    super.initState();
  }

  void fetchMoreData(int page) async {
    final data = await widget.data.loadMoreData?.call(page);
    if (data != null) {
      list.addAll(data.metaResponses);
    }
  }

  void _listener() {
    if (widget.controller.position.pixels ==
        widget.controller.position.maxScrollExtent) {
      setState(() {
        page++;
        // fetchMoreData(page);
      });
    }
  }

  @override
  void deactivate() {
    widget.controller.removeListener(_listener);

    super.deactivate();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height != defaultPosterBoxHeight
        ? widget.height + 10
        : widget.height;
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            controller: widget.controller,
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final data = list[index];
              return Padding(
                  padding: EdgeInsets.only(
                      left: (index == 0) ? widget.paddingAtStart : 0.0,
                      right:
                          (index != list.length - 1) ? widget.spaceBetween : 0),
                  child: ImageButtonWrapper(
                    onTap: () {},
                    child: ImageHolder.withText(
                      textStyle: widget.textStyle,
                      imageUrl: data.poster ?? '',
                      height: height,
                      width: widget.width,
                      text: data.title ?? data.romanji ?? data.native ?? '',
                    ),
                  ));
            }),
      ),
    );
  }
}
