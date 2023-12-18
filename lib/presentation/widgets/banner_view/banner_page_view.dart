// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/banner_view/state_management.dart/banner_page_view_controller.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'banner_image_holder.dart';
import 'banner_image_text.dart';
import 'banner_row_buttons.dart';

class BannerPageView extends StatefulWidget {
  final HomePage homePage;
  final double height;
  const BannerPageView({super.key, required this.homePage, this.height = 400});

  @override
  State<BannerPageView> createState() => _BannerPageViewState();
}

class _BannerPageViewState extends State<BannerPageView> {
  late final PageController _pageController;

  late final BannerPageViewController _controller;
  late final List<SearchResponse> row;

  @override
  void initState() {
    row = widget.homePage.data.data;
    _pageController = PageController();
    _controller = BannerPageViewController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();

    super.dispose();
  }

  static const _duration = Duration(milliseconds: 300);

  static const _curve = Curves.easeIn;

  Widget pageViewWithDecoratedBox() {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(
            strokeAlign: -0.050, color: context.theme.scaffoldBackgroundColor),
        gradient: LinearGradient(
          begin: const Alignment(0.0, 1.0), // Adjust the begin point
          end: const Alignment(0.0, -1.0),
          colors: [context.theme.scaffoldBackgroundColor, Colors.transparent],
        ),
      ),
      child: _buildPageView(),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      itemCount: row.length,
      controller: _pageController,
      onPageChanged: _controller.onPageChanged,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => BannerImageHolder(
          height: 400, imageUrl: row[index].poster.replaceFirst("'", "")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.height,
        minWidth: width,
        maxHeight: widget.height,
        maxWidth: width,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: pageViewWithDecoratedBox()),
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
          if (!isMobile)
            Positioned.fill(
              child: RotatedBox(
                quarterTurns: 2,
                child: DrawGradient(
                    height: 400,
                    width: width / 2,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
              ),
            ),
          Positioned(
            right: isMobile ? 0 : width / 3.0,
            left: isMobile ? 0 : 50,
            bottom: isMobile ? 20 : 30,
            child: ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  return BannerImageText(
                    showType: row[_controller.page].type,
                    airDate: null,
                    title: row[_controller.page].title,
                    genres: row[_controller.page].generes,
                    rating: row[_controller.page].rating,
                    description: row[_controller.page].description,
                    buttons: BannerButtons(
                      onTapMyList: () {},
                      onTapWatchNow: () {
                        context.go(Routes.info, extra: row[_controller.page]);
                      },
                    ),
                  );
                }),
          ),
          if (!isMobile)
            Positioned(
              right: 120,
              bottom: 0,
              // bottom: defaultHeight,
              child: _ArrowButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 25,
                  ),
                  onTap: () {
                    if (_pageController.page?.round() == 0) {
                      _pageController.jumpTo(
                        row.length - 1,
                      );
                    } else {
                      _pageController.previousPage(
                          duration: _duration, curve: _curve);
                    }
                  }),
            ),
          if (!isMobile)
            Positioned(
              right: 50,
              bottom: 0,
              // bottom: defaultHeight,
              child: _ArrowButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 25,
                  ),
                  onTap: () {
                    if (_pageController.page == row.length - 1) {
                      _pageController.jumpTo(
                        0,
                      );
                    } else {
                      _pageController.nextPage(
                          duration: _duration, curve: _curve);
                    }
                  }),
            )
        ],
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  final Icon icon;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  const _ArrowButton(
      {super.key,
      required this.icon,
      required this.onTap,
      this.width,
      this.height});

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final shape = CircleBorder(
        side: BorderSide(color: context.theme.colorScheme.onSurface, width: 2));
    final defaultSize = widget.icon.size ?? 30;
    return Material(
      shape: shape,
      animationDuration: const Duration(milliseconds: 100),
      color: Colors.transparent,
      child: InkWell(
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        onFocusChange: (value) {
          setState(() {
            isHovered = value;
          });
        },
        focusColor: context.theme.colorScheme.onSurface,
        hoverColor: context.theme.colorScheme.onSurface,
        customBorder: shape,
        onTap: widget.onTap,
        child: SizedBox(
          height: defaultSize + 30,
          width: defaultSize + 30,
          child: Icon(
            widget.icon.icon,
            color: isHovered
                ? context.theme.colorScheme.surface
                : (widget.icon.color ?? context.theme.colorScheme.onSurface),
            size: widget.icon.size,
            fill: widget.icon.fill,
            weight: widget.icon.weight,
            grade: widget.icon.grade,
            opticalSize: widget.icon.opticalSize,
            shadows: widget.icon.shadows,
            semanticLabel: widget.icon.semanticLabel,
            textDirection: widget.icon.textDirection,
          ),
        ),
      ),
    );
  }
}
