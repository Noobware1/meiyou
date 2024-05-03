// ignore_for_file: unused_element

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Gradient;
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/extensions/double.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/presentation/core/image_holder.dart';

import 'package:meiyou/presentation/core/gradient.dart';
import 'package:meiyou/presentation/home/banner/banner_button/banner_button.dart';
import 'package:meiyou/presentation/home/banner/banner_page_controller.dart';
import 'package:meiyou/presentation/home/banner/banner_text/banner_text.dart';
import 'package:nice_dart/nice_dart.dart';

class BannerView extends StatefulWidget {
  final HomePageRequest request;
  final HomePage homepage;
  final void Function(ContentItem) onItemSelected;
  final void Function(ContentItem) onAddToLibrary;
  const BannerView({
    super.key,
    required this.request,
    required this.homepage,
    required this.onItemSelected,
    required this.onAddToLibrary,
  });

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  late final BannerPageController controller;

  static const height = 400.0;

  @override
  void initState() {
    controller = BannerPageController(PageController());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget topGrandient({required double width}) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Gradient(
        height: 60,
        begin: const Alignment(0, 1.0),
        end: const Alignment(0.0, -0.5),
        colors: [Colors.transparent, context.theme.scaffoldBackgroundColor],
      ),
    );
  }

  Widget sideGradient({required double width}) {
    return Container(
      alignment: Alignment.centerRight,
      child: RotatedBox(
        quarterTurns: 2,
        child: Gradient(
            height: height,
            width: width / 2,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
      ),
    );
  }

  Widget bannerView(
      {required double width, required Iterable<ContentItem> items}) {
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
      child: PageView.builder(
        itemCount: items.length,
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => ImageHolder(
          height: height,
          width: width,
          imageUrl: items.get(index).poster,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget bannerText(
      {required ScreenSize screenSize, required Iterable<ContentItem> items}) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final item = items.get(controller.currentPage);
        return BannerText.forScreenSize(item: item, screenSize: screenSize);
      },
    );
  }

  Widget bannerButton({
    required ScreenSize screenSize,
    required void Function() onItemSelected,
    required void Function() onAddToList,
  }) {
    return BannerButton.forScreenSize(
      screenSize,
      onItemSelected: onItemSelected,
      onAddToList: onAddToList,
    );
  }

  Widget bannerContent({
    required ScreenSize screenSize,
    required double width,
    required Iterable<ContentItem> items,
  }) {
    final isMobile = screenSize.isMobile;

    return Container(
      margin: EdgeInsets.only(
        right: isMobile ? 0 : width / 3.0,
        left: isMobile ? 0 : 50,
        bottom: isMobile ? 20 : 30,
      ),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bannerText(screenSize: screenSize, items: items),
          bannerButton(
            screenSize: screenSize,
            onItemSelected: () {
              widget.onItemSelected(items.get(controller.currentPage));
            },
            onAddToList: () {
              widget.onAddToLibrary(items.get(controller.currentPage));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.homepage.data.map((e) => e.items).flattened;
    return LayoutBuilder(builder: (context, boxConstraints) {
      final width = boxConstraints.maxWidth;

      final screenSize = width.screenSize;
      return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            bannerView(
              items: items,
              width: width,
            ),
            topGrandient(width: width),
            if (screenSize.isDesktop) sideGradient(width: width),
            bannerContent(screenSize: screenSize, width: width, items: items),
          ],
        ),
      );
    });
  }
}
