import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/assets.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'image_text.dart';

class _ImageHolderWithText extends ImageHolder {
  const _ImageHolderWithText({
    super.imageUrl,
    super.height,
    super.width,
    this.textStyle,
    required this.text,
    super.backgroundColor,
    this.children,
    super.borderRadius,
    super.fit,
  });

  final String text;
  final TextStyle? textStyle;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
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
              borderRadius: borderRadius,
              fit: fit,
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: width,
              child: Align(
                alignment: Alignment.topLeft,
                child: ImageText(
                  text: text,
                  textStyle: textStyle,
                ),
              ),
            ),
            if (children != null)
              SizedBox(
                width: width,
                child: Column(
                  children: children!,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _ImageHolderWithWatchData extends ImageHolder {
  const _ImageHolderWithWatchData(
      {super.imageUrl,
      super.height,
      super.width,
      this.textStyle,
      required this.text,
      super.backgroundColor,
      this.watched,
      this.current,
      this.total,
      this.watchDataTextStyle,
      super.borderRadius,
      super.fit});

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
      borderRadius: borderRadius,
      fit: fit,
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
  final String? imageUrl;
  final Color? backgroundColor;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;

  const ImageHolder(
      {super.key,
      this.height = defaultPosterHeight,
      this.width = defaultPosterBoxWidth,
      this.borderRadius,
      this.imageUrl,
      this.backgroundColor,
      this.fit});

  factory ImageHolder.withWatchData({
    double height = defaultPosterBoxHeight,
    double width = defaultPosterBoxWidth,
    TextStyle? textStyle,
    TextStyle? watchDataTextStyle,
    Color? backgroundColor,
    String? imageUrl,
    BorderRadiusGeometry? borderRadius,
    required String text,
    int? watched,
    int? current,
    int? total,
    BoxFit? fit,
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
      fit: fit,
      borderRadius: borderRadius,
      watchDataTextStyle: watchDataTextStyle,
    );
  }

  factory ImageHolder.withText({
    double height = defaultPosterBoxHeight,
    double width = defaultPosterBoxWidth,
    TextStyle? textStyle,
    Color? backgroundColor,
    String? imageUrl,
    BorderRadiusGeometry? borderRadius,
    required String text,
    List<Widget>? children,
    BoxFit? fit,
  }) {
    return _ImageHolderWithText(
      imageUrl: imageUrl,
      text: text,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
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
          color: context.theme.scaffoldBackgroundColor,
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(10))),
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: _imageBuilder(imageUrl: imageUrl, height: height, width: width),
      ),
    );
  }

  Widget _imageBuilder(
      {String? imageUrl, required double height, required double width}) {
    if (imageUrl == null) {
      return fallbackAssetImage(height: height, width: width);
    }
    return imageUrl.startsWith('http') || imageUrl.isEmpty
        ? CachedNetworkImage(
            errorWidget: (context, url, error) =>
                fallbackAssetImage(height: height, width: width, fit: fit),
            imageUrl: imageUrl,
            height: height,
            width: width,
            fit: fit ?? BoxFit.fill,
          )
        : Image.file(
            File(imageUrl),
            height: height,
            width: width,
            fit: fit ?? BoxFit.fill,
          );
  }
}

Widget fallbackAssetImage(
    {required double height, required double width, BoxFit? fit}) {
  return Image.asset(
    defaultposterImage,
    height: height,
    width: width,
    fit: fit ?? BoxFit.fill,
  );
}
