import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'image_text.dart';

class ImageHolder extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;

  const ImageHolder(
      {super.key,
      this.height = defaultPosterHeight,
      this.width = defaultPosterBoxWidth,
      required this.imageUrl});

  static withText(
      {double height = defaultPosterBoxHeight,
      double width = defaultPosterBoxWidth,
      TextStyle? textStyle,
      required String imageUrl,
      required String text}) {
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
            height: height == defaultPosterBoxHeight
                ? height - 35
                : height - (textStyle?.fontSize ?? 15) * 3.3,
            width: width,
          ),
          const SizedBox(
            height: 5,
          ),
          ImageText(
            text: text,
            textStyle: textStyle,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10))),
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
