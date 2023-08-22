import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/constants/height_and_width.dart'
    show smallScreenSize;
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/row.dart';
import 'package:meiyou/presentation/widgets/banner_view/state_management.dart/banner_page_view_controller.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/play_button.dart';
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
    final double defaultHeight = widget.height / 2 - 50;
    final width = context.screenWidth;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.height,
        minWidth: width,
        maxHeight: widget.height,
        maxWidth: width,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: bannerRow.length,
            controller: _controller,
            onPageChanged: _bannerPageViewController.onPageChanged,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ResponsiveBuilder(
                forSmallScreen:
                    BannerImageHolder(imageUrl: bannerRow[index].poster ?? ''),
                forLagerScreen: BannerImageHolder(
                    imageUrl: bannerRow[index].bannerImage ??
                        bannerRow[index].poster ??
                        '')),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: DrawGradient(
                height: 100,
                begin: Alignment.bottomCenter,
                end: Alignment.center),
          ),
          ResponsiveBuilder(
              forSmallScreen: defaultSizedBox,
              forLagerScreen: Container(
                  height: 500,
                  decoration: const BoxDecoration(
                      //color: Colors.red,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.black, Colors.black38])))),
          ListenableBuilder(
              listenable: _bannerPageViewController,
              builder: (context, child) {
                return BannerImageText(
                  title: bannerRow[_bannerPageViewController.page].title ??
                      bannerRow[_bannerPageViewController.page].romanji ??
                      bannerRow[_bannerPageViewController.page].native ??
                      'No Title',
                  genres: bannerRow[_bannerPageViewController.page].genres,
                  averageScore:
                      bannerRow[_bannerPageViewController.page].averageScore ??
                          0.0,
                  description:
                      bannerRow[_bannerPageViewController.page].description,
                  buttons: BannerButtons(
                      onTapMyList: () {}, onTapPlay: () {}, onTapInfo: () {}),
                );
              }),
          context.screenWidth < smallScreenSize
              ? defaultSizedBox
              : Positioned(
                  top: 0,
                  bottom: 0,
                  left: (context.screenWidth / 2) + 180,
                  child: PlayButton(
                    height: 200,
                    onTap: () {},
                   
                  )),
          if (!isMobile)
            Positioned(
              left: 0,
              top: defaultHeight,
              bottom: defaultHeight,
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
              bottom: defaultHeight,
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
}

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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: SizedBox(
          height: height ?? deafultSize + 30,
          width: deafultSize + 20,
          child: Material(
              shape: shape,
              animationDuration: const Duration(milliseconds: 100),
              // type: MaterialType.transparency,
              color: Colors.black54,
              child: InkWell(
                customBorder: shape,
                onTap: onTap,
                child: icon,
              )),
        ),
      ),
    );
  }
}
