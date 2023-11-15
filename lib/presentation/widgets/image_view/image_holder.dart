import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'image_text.dart';

class _ImageHolderWithText extends ImageHolder {
  const _ImageHolderWithText({
    required super.imageUrl,
    super.height,
    super.width,
    this.textStyle,
    required this.text,
    super.backgroundColor,
    this.children,
  });

  final String text;
  final TextStyle? textStyle;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      // height: boxHeight,
      width: width,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            ImageHolder(
              imageUrl: imageUrl,
              height: height,
              width: width,
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ImageText(
                text: text,
                textStyle: textStyle,
              ),
            ),
            if (children != null) ...children!
          ],
        ),
      ),
    );
  }
}

class _ImageHolderWithWatchData extends ImageHolder {
  const _ImageHolderWithWatchData({
    required super.imageUrl,
    super.height,
    super.width,
    this.textStyle,
    required this.text,
    super.backgroundColor,
    this.watched,
    this.current,
    this.total,
    this.watchDataTextStyle,
  });

  final String text;
  final TextStyle? textStyle;
  final int? watched;
  final int? current;
  final int? total;
  final TextStyle? watchDataTextStyle;

  @override
  Widget build(BuildContext context) {
    final textStyle = watchDataTextStyle ?? const TextStyle();
    return ImageHolder.withText(
      backgroundColor: backgroundColor,
      height: height,
      width: width,
      textStyle: this.textStyle,
      text: text,
      imageUrl: imageUrl,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: (watched == null || watched == 0)
                    ? '~'
                    : watched!.toString(),
                style: textStyle.copyWith(
                    color: context.theme.colorScheme.primary),
              ),
              if (current != null) ...[
                TextSpan(
                  text: ' | ',
                  style: textStyle.copyWith(color: Colors.grey),
                ),
                TextSpan(
                  text: current?.toString() ?? '~',
                  style: textStyle.copyWith(color: Colors.grey),
                ),
              ],
              TextSpan(
                text: ' | ',
                style: textStyle.copyWith(color: Colors.grey),
              ),
              TextSpan(
                text: total?.toString() ?? '~',
                style: textStyle.copyWith(color: Colors.grey),
              ),
            ]),
          ),
        )
      ],
    );
  }
}

class ImageHolder extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;
  final Color? backgroundColor;

  const ImageHolder(
      {super.key,
      this.height = defaultPosterHeight,
      this.width = defaultPosterBoxWidth,
      required this.imageUrl,
      this.backgroundColor});

  factory ImageHolder.withWatchData({
    double height = defaultPosterBoxHeight,
    double width = defaultPosterBoxWidth,
    TextStyle? textStyle,
    TextStyle? watchDataTextStyle,
    Color? backgroundColor,
    required String imageUrl,
    required String text,
    int? watched,
    int? current,
    int? total,
  }) {
    return _ImageHolderWithWatchData(
      backgroundColor: backgroundColor,
      imageUrl: imageUrl,
      text: text,
      current: current,
      height: height,
      textStyle: textStyle,
      total: total,
      watched: watched,
      width: width,
      watchDataTextStyle: watchDataTextStyle,
    );
  }

  factory ImageHolder.withText({
    double height = defaultPosterBoxHeight,
    double width = defaultPosterBoxWidth,
    TextStyle? textStyle,
    Color? backgroundColor,
    required String imageUrl,
    required String text,
    List<Widget>? children,
  }) {
    return _ImageHolderWithText(
      imageUrl: imageUrl,
      text: text,
      height: height,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      width: width,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.theme.colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: _imageBuilder(imageUrl: imageUrl, height: height, width: width),
      ),
    );
  }
}

Widget _imageBuilder(
    {required String imageUrl, required double height, required double width}) {
  return imageUrl.startsWith('http') || imageUrl.isEmpty
      ? CachedNetworkImage(
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/default-poster.jpg',
            height: height,
            width: width,
            fit: BoxFit.fill,
          ),
          imageUrl: imageUrl,
          height: height,
          width: width,
          fit: BoxFit.fill,
        )
      : Image.file(
          File(imageUrl),
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
}
