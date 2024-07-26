import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/features/home/presentation/widgets/banner_view/banner_view_model.dart';
import 'package:meiyou/features/home/presentation/widgets/banner_view/banner_view_theme_data.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:nice_dart/nice_dart.dart';

class BannerView extends StatefulWidget {
  final StateNotifier<List<Media>> stateListenable;
  final void Function(Media) onPressed;
  final void Function(Media) onLongPressed;
  final void Function() onScrollEnd;
  const BannerView({
    super.key,
    required this.stateListenable,
    required this.onPressed,
    required this.onLongPressed,
    required this.onScrollEnd,
  });

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  late final BannerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = BannerViewModel(
      stateListenable: widget.stateListenable,
      onPressed: widget.onPressed,
      onLongPressed: widget.onLongPressed,
      onScrollEnd: widget.onScrollEnd,
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = BannerViewThemeData.from(context);

    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      final height = theme.getBannerHeightForSize(screenSize);
      final width = constraints.maxWidth;
      return AnimatedContainer(
        duration: Durations.short3,
        height: height,
        width: width,
        child: StateListenableBuilder(
            stateListenable: viewModel.listenable,
            builder: (context, state, _) {
              return Stack(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapDown: (deatils) =>
                          viewModel.onBannerTapDown(deatils, width),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: viewModel.onScroll,
                        child: PageView(
                          controller: viewModel.pageController,
                          children: state.map((media) {
                            return DecoratedBox(
                              position: DecorationPosition.foreground,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    strokeAlign: -0.050,
                                    color: theme.gradientBaseColor),
                                gradient: screenSize.isDesktop
                                    ? sideGradient(theme)
                                    : bottomGradient(theme),
                              ),
                              child: bannerImage(media,
                                  height: height, width: width),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: theme.contentPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: IgnorePointer(
                            child: StateListenableBuilder(
                                stateListenable: viewModel.pageNotifier,
                                builder: (context, page, _) {
                                  final item = state[page];
                                  return ConstrainedBox(
                                    constraints: theme.contentConstraints,
                                    child: BannerContent(
                                      media: item,
                                      theme: theme,
                                      screenSize: screenSize,
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: BannerActionButtons(
                            theme: theme,
                            screenSize: screenSize,
                            onPressed: viewModel.onPressed,
                            onAddToLibrary: viewModel.onLongPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (screenSize.isDesktop)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Padding(
                        padding: theme.contentPadding,
                        child: pageNavigationButton(
                          context,
                          theme,
                        ),
                      ),
                    ),
                ],
              );
            }),
      );
    });
  }

  LinearGradient sideGradient(BannerViewThemeData theme) => theme.sideGradient;

  LinearGradient bottomGradient(BannerViewThemeData theme) =>
      theme.bottomGradient;

  Widget pageNavigationButton(BuildContext context, BannerViewThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: theme.navigationButtonStyle,
          onPressed: viewModel.movePrevious,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        const HorizontalSpace(8),
        IconButton(
          style: theme.navigationButtonStyle,
          onPressed: viewModel.moveNext,
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget bannerImage(
    Media media, {
    required double height,
    required double width,
  }) {
    return ImageHolder.network(
      height: height,
      width: width,
      url: media.poster,
      fit: BoxFit.cover,
    );
  }
}

class BannerActionButtons extends StatelessWidget {
  final BannerViewThemeData theme;
  final VoidCallback onPressed;
  final VoidCallback onAddToLibrary;
  final ScreenSize screenSize;
  const BannerActionButtons({
    super.key,
    required this.theme,
    required this.screenSize,
    required this.onPressed,
    required this.onAddToLibrary,
  });

  @override
  Widget build(BuildContext context) {
    final actionButtonStyle = theme.getActionButtonStyleForSize(screenSize);
    final addToLibraryButtonStyle =
        theme.getAddToLibraryButtonStyleForSize(screenSize);
    final padding = theme.getContentPaddingForSize(screenSize);

    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          FilledButton.icon(
            style: actionButtonStyle,
            onPressed: onPressed,
            label: const Text('Watch Now'),
            icon: const Icon(Icons.play_arrow),
          ),
          const HorizontalSpace(8),
          OutlinedButton.icon(
            style: addToLibraryButtonStyle,
            onPressed: onAddToLibrary,
            label: const Text('Library'),
            icon: const Icon(Icons.add),
          ),
        ]),
      ),
    );
  }
}

class BannerContent extends StatelessWidget {
  final Media media;
  final BannerViewThemeData theme;
  final ScreenSize screenSize;
  const BannerContent({
    super.key,
    required this.media,
    required this.theme,
    required this.screenSize,
  });
  @override
  Widget build(BuildContext context) {
    final titleTextStyle = theme.getTextStyleForSize(screenSize);

    final genreTextStyle = theme.getGenreTextStyleForSize(screenSize);

    final genreSeparatorTextStyle = theme.genreSeparatorTextStyle;

    final descriptionTextStyle =
        theme.getDescriptionTextStyleForSize(screenSize);

    final ratingTextStyle = theme.getRatingTextStyleForSize(screenSize);
    final ratingIconColor = theme.ratingIconColor;
    final ratingIconSize = theme.ratingIconSize;

    final deaultPadding = theme.getContentPaddingForSize(screenSize);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: deaultPadding,
          child: _title(
            title: media.title,
            style: titleTextStyle,
          ),
        ),
        if (media.score != null)
          Flexible(
            child: Padding(
              padding: deaultPadding,
              child: _score(
                media.score!,
                ratingTextStyle,
                ratingIconColor,
                ratingIconSize,
              ),
            ),
          ),
        if (media.genres.isNotEmptyOrNull)
          Padding(
            padding: deaultPadding,
            child: _genres(
              genres: media.genres!,
              genreStyle: genreTextStyle,
              genreSeparatorTextStyle: genreSeparatorTextStyle,
            ),
          ),
        if (media.description.isNotEmptyOrNull)
          Flexible(
            child: Padding(
              padding: deaultPadding,
              child: _description(
                description: media.description!.replaceAll(RegExp(r'\s+'), ' '),
                style: descriptionTextStyle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _score(
    double rating,
    TextStyle textStyle,
    Color iconColor,
    double iconSize,
  ) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(
        Icons.star_rate,
        size: iconSize,
        color: iconColor,
      ),
      const HorizontalSpace(4),
      Text(
        media.score!.toString(),
        style: textStyle,
      ),
    ]);
  }

  Widget _title({required String title, required TextStyle style}) {
    return Text(
      title,
      style: style,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _genres(
      {required List<String> genres,
      required TextStyle genreStyle,
      required TextStyle genreSeparatorTextStyle}) {
    return RichText(
        text: TextSpan(children: [
      for (var i = 0; i < genres.length; i++) ...[
        TextSpan(text: genres[i], style: genreStyle),
        if (i != genres.lastIndex)
          TextSpan(
              text: '  •  ',
              style: TextStyle(color: genreSeparatorTextStyle.color)),
      ]
    ]));
  }

  Widget _description({
    required String description,
    required TextStyle style,
  }) {
    return Text(
      description,
      style: style,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
