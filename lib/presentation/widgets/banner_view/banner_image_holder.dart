import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meiyou/core/constants/assets.dart';

class BannerImageHolder extends StatelessWidget {
  final double height;
  final double? width;
  final String imageUrl;

  const BannerImageHolder(
      {super.key, required this.imageUrl, this.height = 500.0, this.width});

  static Widget withTitleAndGenres(
      {required BuildContext context,
      required String imageUrl,
      required String title,
      List<String>? genres,
      double height = 450.0,
      double? width}) {
    return SizedBox(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          BannerImageHolder(
            imageUrl: imageUrl,
            height: height,
            width: width,
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: SizedBox(
              //color: Colors.red,
              height: 140,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                    ), //overflow: TextOverflow.ellipsis),

                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis),
                    child: Text(
                      (genres ?? ['']).join(' | '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bannerWidth = width ?? MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: bannerWidth,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        fit: BoxFit.cover,
        width: width ?? MediaQuery.of(context).size.width,
        errorWidget: (context, url, error) => Image.asset(
          defaultbannerImage,
          height: height,
          width: bannerWidth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
