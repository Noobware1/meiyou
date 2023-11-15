import 'package:flutter/material.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_image_holder.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';

class BannerHolderForInfo extends StatelessWidget {
  final String url;

  const BannerHolderForInfo({
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        forSmallScreen: Stack(children: [
          BannerImageHolder(
            imageUrl: url,
            height: 400,
          ),
          const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DrawGradient(
                  height: 350,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ]),
        forLagerScreen: Stack(children: [
          Container(
            height: 350,
          ),
          BannerImageHolder(
            imageUrl: url,
            height: 300,
          ),
          const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DrawGradient(
                  height: 350,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ]));
  }
}
