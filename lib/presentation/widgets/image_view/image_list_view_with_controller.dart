import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/row.dart';

import 'image_list_view.dart';

class ImageViewWithScrollController extends StatefulWidget {
  final ImageListViewType type;
  // final String? label;?
  final MetaRowEntity data;
  final double height;
  final double width;
  final void Function(MetaResponseEntity selected)? onSelected;

  // final Future<List<ImageListViewData>?> Function(int page)? fetchMoreData;
  final EdgeInsets padding;
  final double spaceBetween;
  final TextStyle? textStyle;
  final double paddingAtStart;

  final double paddingAtEnd;

  const ImageViewWithScrollController(
      {super.key,
      required this.type,
      this.textStyle,
      this.paddingAtStart = 0.0,
      this.onSelected,
      this.paddingAtEnd = 0.0,
      required this.data,
      this.padding = const EdgeInsets.only(left: 5, right: 5),
      this.spaceBetween = 8,
      // this.fetchMoreData,
      this.height = defaultPosterBoxHeight,
      this.width = defaultPosterBoxWidth});

  @override
  State<ImageViewWithScrollController> createState() =>
      _ImageViewWithScrollControllerState();
}

enum ImageListViewType {
  withButtonAndLabel,
  basic,
  withLabel,
}

class _ImageViewWithScrollControllerState
    extends State<ImageViewWithScrollController> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _default() => ImageListView(
        data: widget.data,
        paddingAtEnd: widget.paddingAtEnd,
        paddingAtStart: widget.paddingAtStart,
        controller: _controller,
    
        textStyle: widget.textStyle,
        onSelected: widget.onSelected,
        height: widget.height,
        padding: widget.padding,
        spaceBetween: widget.spaceBetween,
        width: widget.width,
      );

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case ImageListViewType.basic:
        return _default();
      case ImageListViewType.withLabel:
        return ImageListView.withLabel(
          paddingAtEnd: widget.paddingAtEnd,
          paddingAtStart: widget.paddingAtStart,
          context: context,
          // label:? label,
          data: widget.data,
          onSelected: widget.onSelected,
          textStyle: widget.textStyle,
          controller: _controller,
          // fetchMoreData: widget.fetchMoreData,
          height: widget.height,
          padding: widget.padding,
          spaceBetween: widget.spaceBetween,
          width: widget.width,
        );
      case ImageListViewType.withButtonAndLabel:
        return ImageListView.withButtonAndLabel(
          paddingAtEnd: widget.paddingAtEnd,
          paddingAtStart: widget.paddingAtStart,
          context: context,
          // label: label,
          data: widget.data,
          controller: _controller,
          onSelected: widget.onSelected,
          // fetchMoreData: widget.fetchMoreData,
          height: widget.height,
          padding: widget.padding,
          spaceBetween: widget.spaceBetween,
          textStyle: widget.textStyle,
          width: widget.width,
        );
      default:
        return _default();
    }
  }
}
