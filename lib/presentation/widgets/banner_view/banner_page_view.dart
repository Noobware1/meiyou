import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/row.dart';
import 'package:meiyou/presentation/widgets/banner_view/state_management.dart/banner_page_view_controller.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'banner_image_holder.dart';
import 'banner_image_text.dart';
import 'banner_row_buttons.dart';

class BannerPageView extends StatefulWidget {
  final MetaRowEntity bannerRow;
  final double height;
  const BannerPageView({super.key, required this.bannerRow, this.height = 500});

  @override
  State<BannerPageView> createState() => _BannerPageViewState();
}

class _BannerPageViewState extends State<BannerPageView> {
  late final PageController _controller;

  late final BannerPageViewController _bannerPageViewController;
  late final List<MetaResponseEntity> bannerRow;

  @override
  void initState() {
    bannerRow = widget.bannerRow.resultsEntity.metaResponses;
    _controller = PageController();
    _bannerPageViewController = BannerPageViewController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bannerPageViewController.dispose();

    super.dispose();
  }

  static const _duration = Duration(milliseconds: 300);

  static const _curve = Curves.easeIn;

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = 400 / 2;

    final width = context.screenWidth;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 400,
        minWidth: width,
        maxHeight: 400,
        maxWidth: width,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                // border: Border.all(strokeAlign: -0.050),
                gradient: LinearGradient(
                  begin: const Alignment(0.0, 1.0), // Adjust the begin point
                  end: const Alignment(0.0, -1.0),
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                  colors: [
                    context.theme.scaffoldBackgroundColor,
                    Colors.transparent
                    // Color.fromARGB(255, 0, 0, 0), // Dark color at the bottom
                    // Color.fromARGB(120, 0, 0, 0), // Slightly lighter
                    // Color.fromARGB(0, 0, 0, 0), // Transparent in the middle
                  ],
                ),
              ),
              child: PageView.builder(
                itemCount: bannerRow.length,
                controller: _controller,
                onPageChanged: _bannerPageViewController.onPageChanged,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => BannerImageHolder(
                    height: 400, imageUrl: bannerRow[index].poster ?? ''),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: RotatedBox(
              quarterTurns: 2,
              child: DrawGradient(
                  height: 60,
                  begin: Alignment(0, 0.0),
                  end: Alignment(0.0, 50)),
            ),
          ),
          Positioned(
            right: isMobile ? 0 : 50,
            left: isMobile ? 0 : 50,
            bottom: 0,
            child: ListenableBuilder(
                listenable: _bannerPageViewController,
                builder: (context, child) {
                  return BannerImageText(
                    mediaType:
                        bannerRow[_bannerPageViewController.page].mediaType ??
                            'Other',
                    releaseDate:
                        bannerRow[_bannerPageViewController.page].airDate,
                    title: bannerRow[_bannerPageViewController.page].title ??
                        bannerRow[_bannerPageViewController.page].romanji ??
                        bannerRow[_bannerPageViewController.page].native ??
                        'No Title',
                    genres: bannerRow[_bannerPageViewController.page].genres,
                    averageScore: bannerRow[_bannerPageViewController.page]
                            .averageScore ??
                        0.0,
                    description:
                        bannerRow[_bannerPageViewController.page].description,
                    buttons: BannerButtons(
                        onTapMyList: () {},
                        onTapPlay: () {
                          context.go('$homeRoute/$watch',
                              extra: bannerRow[_bannerPageViewController.page]);
                        },
                        onTapInfo: () {
                          context.go('$homeRoute/$watch',
                              extra: bannerRow[_bannerPageViewController.page]);
                        }),
                  );
                }),
          ),
          if (!isMobile)
            Positioned(
              left: 0,
              top: defaultHeight,
              // bottom: defaultHeight,
              child: ArrowButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 40,
                  ),
                  onTap: () {
                    if (_controller.page?.round() == 0) {
                      _controller.jumpTo(
                        bannerRow.length - 1,
                      );
                    } else {
                      _controller.previousPage(
                          duration: _duration, curve: _curve);
                    }
                  }),
            ),
          if (!isMobile)
            Positioned(
              right: 0,
              top: defaultHeight,
              // bottom: defaultHeight,
              child: ArrowButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 40,
                  ),
                  onTap: () {
                    if (_controller.page == bannerRow.length - 1) {
                      _controller.jumpTo(
                        0,
                      );
                    } else {
                      _controller.nextPage(duration: _duration, curve: _curve);
                    }
                  }),
            )
        ],
      ),
    );
  }

  // return ConstrainedBox(
  //   constraints: BoxConstraints(
  //     minHeight: 300,
  //     minWidth: width,
  //     maxHeight: widget.height,
  //     maxWidth: width,
  //   ),
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: [

  //         // const Positioned.fill(
  //         //   child: RotatedBox(
  //         //     quarterTurns: 4,
  //         //     child: DrawGradient(
  //         //         height: 200,
  //         //         begin: Alignment.bottomCenter,
  //         //         end: Alignment.topCenter),
  //         //   ),
  //         // ),
  //         const ResponsiveBuilder(
  //             forSmallScreen: defaultSizedBox,
  //             forLagerScreen: DrawGradient(
  //               height: 500,
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //             )),

  //       ],
  //     ),
  //   );
}

// class _ForSmallScreens extends StatelessWidget {
//   final PageController controller;

//   final BannerPageViewController _bannerPageViewController;
//   final List<MetaResponseEntity> bannerRow;
//   const _ForSmallScreens(
//       {required this.controller,
//       required this._bannerPageViewController,
//       required this.bannerRow});

//   }
// }

class ArrowButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final ShapeBorder? shape;
  const ArrowButton(
      {super.key,
      this.shape,
      required this.icon,
      required this.onTap,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    final deafultSize = icon.size ?? 30;
    return SizedBox(
      height: height ?? deafultSize + 30,
      width: deafultSize + 20,
      child: Material(
          shape: shape,
          animationDuration: const Duration(milliseconds: 100),
          // type: MaterialType.transparency,
          color: context.theme.colorScheme.brightness == Brightness.dark
              ? Colors.black54
              : Colors.white54,
          child: InkWell(
            customBorder: shape,
            onTap: onTap,
            child: icon,
          )),
    );
  }
}
