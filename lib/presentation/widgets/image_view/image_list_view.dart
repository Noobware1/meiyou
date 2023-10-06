import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/row.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'image_holder.dart';

class ImageListView extends StatefulWidget {
  final double height;
  final double width;
  final void Function(MetaResponseEntity selected)? onSelected;
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
      this.onSelected,
      required this.controller,
      this.paddingAtStart = 0.0,
      this.paddingAtEnd = 0.0,
      this.padding = const EdgeInsets.only(left: 5, right: 5),
      this.spaceBetween = 6,
      this.height = defaultPosterBoxHeight,
      this.width = defaultPosterBoxWidth});

  @override
  State<ImageListView> createState() => _ImageListViewState();

  static Widget withLabel(
      {required BuildContext context,
      required ScrollController controller,
      required MetaRowEntity data,
      final void Function(MetaResponseEntity selected)? onSelected,
      double paddingAtStart = 0.0,
      double paddingAtEnd = 0.0,
      EdgeInsets padding = const EdgeInsets.only(left: 2, right: 5),
      EdgeInsets labelPadding = const EdgeInsets.only(left: 10),
      double spaceBetween = 6,
      TextStyle? textStyle,
      TextStyle labelTextStyle =
          const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      double height = defaultPosterBoxHeight,
      double width = defaultPosterBoxWidth}) {
    return SizedBox(
      height: (height != defaultPosterBoxHeight ? height + 35 : height) + 42,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 32,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Container(
                      decoration: BoxDecoration(
                          color: context.theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(15)),
                      // color: context.primaryColor,
                      width: 5,
                    ),
                  ),
                  addHorizontalSpace(10),

                  Text(
                    data.rowTitle,
                    style: labelTextStyle,
                    textAlign: TextAlign.start,
                  ),
                  // Container(
                  //   alignment: Alignment.bottomRight,
                  //   color: Colors.blue,
                  //   child: IconButton(
                  //       alignment: Alignment.bottomRight,
                  //       iconSize: 25,
                  //       onPressed: () {},
                  //       icon: Transform.rotate(
                  //           angle: 180 * pi / 180,
                  //           child: Icon(
                  //             Icons.arrow_back_rounded,
                  //           ))),
                  // )
                ],
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
            onSelected: onSelected,
            textStyle: textStyle,
            padding: padding,
            spaceBetween: spaceBetween,
            width: width,
            paddingAtStart: paddingAtStart,
            paddingAtEnd: paddingAtEnd,
          )
        ],
      ),
    );
  }

  static Widget withButtonAndLabel(
      {required BuildContext context,
      required ScrollController controller,
      required MetaRowEntity data,
      final void Function(MetaResponseEntity selected)? onSelected,
      TextStyle? textStyle,
      double paddingAtStart = 0.0,
      double paddingAtEnd = 0.0,
      EdgeInsets padding = const EdgeInsets.only(left: 3, right: 3),
      TextStyle labelTextStyle =
          const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      double spaceBetween = 6,
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
            onSelected: onSelected,
            context: context,
            data: data,
            textStyle: textStyle,
            labelTextStyle: labelTextStyle,
            paddingAtStart: paddingAtStart,
            paddingAtEnd: paddingAtEnd,
            width: width,
            height: height,
            padding: padding,
            spaceBetween: spaceBetween),
        Positioned(
          left: 0,
          top: 40,
          bottom: 35,
          child: ArrowButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 40,
            ),
            onTap: () => controller.animateTo(controller.position.pixels - 300,
                duration: animationDuration,
                curve: Curves.fastEaseInToSlowEaseOut),
            shape: shape,
          ),
        ),
        Positioned(
          right: 0,
          top: 40,
          bottom: 35,
          child: ArrowButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 40,
            ),
            shape: shape,
            onTap: () => controller.animateTo(controller.position.pixels + 300,
                duration: animationDuration,
                curve: Curves.fastEaseInToSlowEaseOut),
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
    try {
      final data = await widget.data.loadMoreData?.call(page);
      if (data != null) {
        list.addAll(data.metaResponses);
        setState(() {});
      }
    } catch (_) {}
  }

  void _listener() {
    if (widget.controller.position.pixels ==
        widget.controller.position.maxScrollExtent) {
      setState(() {
        page++;
        fetchMoreData(page);
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
    // return Padding(
    //   padding: widget.padding,

    return Padding(
      padding: widget.padding,
      child: SizedBox(
        // color: Colors.red,
        height: height,
        width: MediaQuery.of(context).size.width,
        child: MediaQuery.removePadding(
          context: context,
          removeLeft: true,
          removeRight: true,
          child: ListView.builder(
              controller: widget.controller,
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.only(
                        left: (index == 0) ? widget.paddingAtStart : 0.0,
                        right: (index != list.length - 1)
                            ? widget.spaceBetween
                            : 0),
                    child: ImageButtonWrapper(
                      onTap: () {
                        widget.onSelected?.call(list[index]);
                      },
                      child: ImageHolder.withText(
                        textStyle: widget.textStyle,
                        imageUrl: list[index].poster ?? '',
                        height: height,
                        width: widget.width,
                        text: list[index].title ??
                            list[index].romanji ??
                            list[index].native ??
                            '',
                      ),
                    ));
              }),
        ),
      ),
    );
    //   ),
    // );
  }
}
