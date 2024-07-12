import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/library/library_preferences.dart';

import 'package:meiyou/presentation/core/future_widget.dart';
import 'package:meiyou/presentation/home/services/homepage_row_service.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/presentation/core/poster_holder.dart';
import 'package:meiyou/presentation/core/poster_view/poster_view.dart';
import 'package:meiyou/presentation/core/space.dart';

class HomePageRow extends FutureWidget<HomePage> {
  final HomePageRequest? request;
  final void Function(ContentItem) onItemSelected;
  final void Function(ContentItem) onAddToLibrary;
  final bool endlessScroll;
  const HomePageRow({
    super.key,
    required super.initialData,
    this.request,
    required this.onItemSelected,
    required this.onAddToLibrary,
    this.endlessScroll = true,
  });

  static const defaultLabelTextStyleMobile = TextStyle(
    fontSize: MobileFontSize.large,
    fontWeight: FontWeight.w700,
  );

  static const defaultLabelTextStyleDesktop = TextStyle(
    fontSize: DesktopFontSize.large,
    fontWeight: FontWeight.w700,
  );

  static const labelBoxSize = 32.0;

  static const spacing = 10.0;

  static const paddingAtStart = 10.0;

  @override
  FutureState<HomePage, HomePageRow> createState() => _HomePageRowState();
}

class _HomePageRowState extends FutureState<HomePage, HomePageRow> {
  late final HomePageRowService? service;

  @override
  void initState() {
    super.initState();
    if (widget.endlessScroll) {
      service = HomePageRowService(getIt.get(), widget.request!);
    } else {
      service = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    final ScreenSize screenSize = ScreenSize.fromWidth(width);
    final bool isMobile = screenSize.isMobile;
    final textTheme = context.theme.textTheme;
    final double posterHeight =
        isMobile ? defaultPosterHeightMobile : defaultPosterHeightDesktop;
    final double posterWidth =
        isMobile ? defaultPosterWidthMobile : defaultPosterWidthDesktop;
    final TextStyle titleTextStyle = isMobile
        ? PosterHolder.titleTextStyleMobile
        : PosterHolder.titleTextStyleDesktop;

    final TextStyle infoTextStyle = isMobile
        ? PosterHolder.infoTextStyleMobile
        : PosterHolder.infoTextStyleDesktop;

    final double posterViewHeight = isMobile
        ? defaultPosterWithSearchResponseHeightMobile
        : defaultPosterWithSearchResponseHeightDesktop;

    final labelTextStyle =
        (isMobile ? textTheme.titleLarge : textTheme.headlineSmall)!.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(state.value!.data.length, (index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildLabel(
              isMobile: isMobile,
              context: context,
              labelTextStyle: labelTextStyle,
              homePageData: state.value!.data[index],
            ),
            const VerticalSpace(HomePageRow.spacing),
            _BuildPosterView(
              isMobile: isMobile,
              posterViewHeight: posterViewHeight,
              posterHeight: posterHeight,
              posterWidth: posterWidth,
              titleTextStyle: titleTextStyle,
              infoTextStyle: infoTextStyle,
              homePageData: state.value!.data[index],
              onScrollEnd: onScrollEnd,
              onItemSelected: widget.onItemSelected,
              onAddToLibary: widget.onAddToLibrary,
            )
          ],
        );
      }),
    );
  }

  void onScrollEnd() {
    if (service == null) return;
    resetFuture(service!
        .loadNextPage(getIt.get<SelectedSource>().source!, state.value!));
  }
}

class _BuildLabel extends StatelessWidget {
  const _BuildLabel({
    super.key,
    required this.isMobile,
    required this.context,
    required this.labelTextStyle,
    required this.homePageData,
  });

  final bool isMobile;
  final BuildContext context;
  final TextStyle labelTextStyle;
  final HomePageData homePageData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomePageRow.labelBoxSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: !isMobile
                ? null
                : const EdgeInsets.only(left: HomePageRow.spacing),
            width: 5,
            decoration: BoxDecoration(
                color: context.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(15)),
          ),
          const HorizontalSpace(10),
          Text(homePageData.name, style: labelTextStyle),
        ],
      ),
    );
  }
}

class _BuildPosterView extends StatelessWidget {
  const _BuildPosterView({
    super.key,
    required this.isMobile,
    required this.posterViewHeight,
    required this.posterHeight,
    required this.posterWidth,
    required this.titleTextStyle,
    required this.infoTextStyle,
    required this.homePageData,
    required this.onScrollEnd,
    required this.onItemSelected,
    required this.onAddToLibary,
  });

  final bool isMobile;
  final double posterViewHeight;
  final double posterHeight;
  final double posterWidth;
  final TextStyle titleTextStyle;
  final TextStyle infoTextStyle;
  final HomePageData homePageData;
  final VoidCallback onScrollEnd;
  final void Function(ContentItem) onItemSelected;
  final void Function(ContentItem) onAddToLibary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: posterViewHeight,
      child: PosterView(
        padding: !isMobile ? null : HomePageRow.paddingAtStart,
        spacing: HomePageRow.spacing,
        onViewFinished: onScrollEnd,
        itemBuilder: (context, index) {
          return ClickablePosterHolder(
            onTap: () {
              onItemSelected(homePageData.items[index]);
            },
            onLongPress: () {
              onAddToLibary(homePageData.items[index]);
            },
            holder: PosterHolderWithTitle(
              height: posterHeight,
              width: posterWidth,
              title: homePageData.items[index].title,
              textStyle: titleTextStyle,
              fit: BoxFit.fill,
            ),
          );
        },
        itemCount: homePageData.items.length,
      ),
    );
  }
}
