import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'image_text.dart';

class _ImageHolderWithText extends ImageHolder {
  const _ImageHolderWithText({
    required super.imageUrl,
    super.height,
    super.width,
    this.textStyle,
    required this.text,
  });

  final String text;
  final TextStyle? textStyle;

  @override
  double get imageHeight => height == defaultPosterBoxHeight
      ? height - 35
      : height - (textStyle?.fontSize ?? 15) * 3.3;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      height: height != defaultPosterBoxHeight ? height + 10 : height,
      width: width,
      child: Column(
        children: [
          ImageHolder(
            imageUrl: imageUrl,
            height: imageHeight,
            width: width,
          ),
          const SizedBox(
            height: 5,
          ),
          ImageText(
            text: text,
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }
}

class _ImageHolderWithEpisodeMetaData extends ImageHolder {
  const _ImageHolderWithEpisodeMetaData({
    required super.imageUrl,
    super.height = defaultPosterBoxWithEpisodeHeight,
    super.width,
    this.textStyle,
    required this.text,
    this.watched,
    this.current,
    this.total,
  });

  final int? watched;
  final int? current;
  final int? total;

  final String text;
  final TextStyle? textStyle;

  @override
  double get imageHeight => height == defaultPosterBoxWithEpisodeHeight
      ? height - 35
      : height - (textStyle?.fontSize ?? 15) * 3.3;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      // height:
      //     height != defaultPosterBoxWithEpisodeHeight ? height + 10 : height,
      width: width,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageHolder(
            imageUrl: imageUrl,
            height: imageHeight,
            width: width,
          ),
          const SizedBox(
            height: 5,
          ),
          ImageText(
            text: text,
            textStyle: textStyle,
          ),
          addVerticalSpace(5),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: watched?.toString() ?? "~",
                style: TextStyle(
                    color: context.theme.colorScheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            TextSpan(
                text: ' | ${current?.toString() ?? "~"} | ',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            TextSpan(
                text: total?.toString() ?? "~",
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ])),
          addVerticalSpace(5)
        ],
      ),
    );
  }
}

class ImageHolder extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;

  double get imageHeight => height;

  const ImageHolder(
      {super.key,
      this.height = defaultPosterHeight,
      this.width = defaultPosterBoxWidth,
      required this.imageUrl});

  static withTextAndEpisodesData({
    double height = defaultPosterBoxHeight,
    double width = defaultPosterBoxWidth,
    TextStyle? textStyle,
    required String imageUrl,
    required String text,
    int? watched,
    int? current,
    int? total,
  }) {
    return _ImageHolderWithEpisodeMetaData(
      imageUrl: imageUrl,
      text: text,
      current: current,
      height: height,
      textStyle: textStyle,
      total: total,
      watched: watched,
      width: width,
    );
  }

  factory ImageHolder.withText(
      {double height = defaultPosterBoxHeight,
      double width = defaultPosterBoxWidth,
      TextStyle? textStyle,
      required String imageUrl,
      required String text}) {
    return _ImageHolderWithText(
      imageUrl: imageUrl,
      text: text,
      height: height,
      textStyle: textStyle,
      width: width,
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
        child: CachedNetworkImage(
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
        ),
      ),
    );
  }
}
