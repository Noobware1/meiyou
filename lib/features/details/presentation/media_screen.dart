import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/details/domain/models/media_screen_state.dart';
import 'package:meiyou/features/details/domain/models/media_screen_theme_data.dart';
import 'package:meiyou/features/details/presentation/media_screen_theme.dart';
import 'package:meiyou/features/details/presentation/media_screen_view_model.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder_theme.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder_theme_data.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view_theme.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view_theme_data.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaScreen extends StatefulWidget {
  final int mediaId;
  final ExtensionCategory category;
  const MediaScreen({
    super.key,
    required this.mediaId,
    required this.category,
  });

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with SingleTickerProviderStateMixin {
  late final MediaScreenViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = MediaScreenViewModel(
      mediaId: widget.mediaId,
      category: widget.category,
      tickerProvider: this,
    );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, constraints, size) {
      final themeDataDesktop =
          MediaScreenThemeDataDesktop(context, constraints);
      final themeDataMobile = MediaScreenThemeDataMobile(context, constraints);

      final currentTheme = size.whenDesktop(() => themeDataDesktop,
          orElse: () => themeDataMobile);

      return MediaScreenTheme(
        desktopData: themeDataDesktop,
        mobileData: themeDataMobile,
        screenSize: size,
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
          ),
          extendBodyBehindAppBar: true,
          body: RefreshIndicator(
            key: viewModel.refreshIndicatorKey,
            displacement: 80.0,
            onRefresh: viewModel.refresh,
            notificationPredicate: (notification) {
              return notification.depth == 0;
            },
            child: SingleChildScrollView(
              controller: viewModel.scrollController,
              child: StateListenableBuilder(
                stateListenable: viewModel.stateListenable,
                builder: (context, state, _) {
                  final media = state.media;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: Durations.short4,
                        height: currentTheme.stackHeight,
                        child: Stack(
                          children: [
                            VerticalSpace(currentTheme.stackHeight),
                            _banner(
                              height: currentTheme.bannerHeight,
                              width: currentTheme.bannerWidth,
                              fit: currentTheme.bannerFit,
                              gradient: currentTheme.bannerGradient,
                              url: media.bannerOrPoster,
                            ),
                            Positioned(
                              bottom: currentTheme.posterPosition,
                              child: _posterAndTitle(
                                media: media,
                                theme: currentTheme,
                                size: size,
                                buttons: disapperingButtonsDesktop(
                                    size: size, state: state),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalSpace(currentTheme.spacing),
                      Padding(
                        padding: currentTheme.defaultPadding,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: currentTheme.spacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!size.isDesktop)
                                  VerticalSpace(currentTheme.spacing),
                                disapperingButtonsMobile(
                                    size: size, state: state),
                                VerticalSpace(currentTheme.spacing),
                                _MetaData(
                                  media: media,
                                  size: size,
                                ),
                                VerticalSpace(currentTheme.spacing),
                                description(
                                  size: size,
                                  theme: currentTheme,
                                  description:
                                      media.description.isNotEmptyOrNull
                                          ? media.description!
                                          : 'No description',
                                  otherTitles: media.otherTitles,
                                ),
                                if (media.genres.isNotEmptyOrNull) ...[
                                  VerticalSpace(currentTheme.spacing),
                                  ChipTheme(
                                    data: currentTheme.genreChipTheme,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 10,
                                      children: media.genres!.mapList(
                                        (e) => FilterChip(
                                          onSelected: (_) => {},
                                          visualDensity:
                                              currentTheme.genreVisualDensity,
                                          label: Text(e),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                VerticalSpace(currentTheme.spacing),
                              ],
                            ),
                          ),
                        ),
                      ),
                      VerticalSpace(currentTheme.spacing),
                      ContentListViewTheme(
                        screenSize: size,
                        desktopData: ContentListViewThemeDataDesktop(context),
                        mobileData: ContentListViewThemeDataMobile(context),
                        tabletData: ContentListViewThemeDataTablet(context),
                        child: ContentHolderTheme(
                          screenSize: size,
                          desktopData: ContentHolderThemeDataDesktop(context),
                          mobileData: ContentHolderThemeDataMobile(context),
                          tabletData: ContentHolderThemeDataTablet(context),
                          child: ContentListView(
                            type: state.contentListViewType,
                            size: size,
                            media: media,
                            contentList: state.contentList,
                            scrollable: false,
                            onViewTypeChange: viewModel.toggleViewType,
                            padding: currentTheme.defaultPadding,
                            spacing: currentTheme.spacing,
                            progress: viewModel.progressContoller,
                            isRefreshing: state.isRefreshing,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget disapperingButtonsDesktop(
      {required ScreenSize size, required MediaScreenState state}) {
    return disappearingButtons(
        visible: size.isDesktop, size: ScreenSize.desktop, state: state);
  }

  Widget disapperingButtonsMobile(
      {required ScreenSize size, required MediaScreenState state}) {
    return disappearingButtons(
        visible: !size.isDesktop, size: ScreenSize.mobile, state: state);
  }

  Widget disappearingButtons({
    required bool visible,
    required ScreenSize size,
    required MediaScreenState state,
  }) {
    return Visibility(
      maintainAnimation: true,
      maintainState: true,
      maintainSemantics: false,
      maintainSize: false,
      maintainInteractivity: false,
      visible: visible,
      child: _MediaScreenButtons(
        size: size,
        isFavorite: state.media.favorite,
        onPressedFavorite: () => viewModel.toggleFavorite(),
        isTracked: false,
        onPressedTracking: () => viewModel.trackMedia(),
        onPressedWebview: () => viewModel.openWebView(),
      ),
    );
  }

  Widget description({
    required MediaScreenThemeData theme,
    required ScreenSize size,
    required String description,
    required List<String>? otherTitles,
  }) {
    return ExpandableText(
      description.let((it) {
        if (otherTitles.isNotEmptyOrNull) {
          return '$it\n\nAlternative names: ${otherTitles!.join(', ')}';
        } else {
          return it;
        }
      }),
      expandText: 'Read more',
      collapseText: 'Read less',
      style: theme.descriptionTextStyle,
      maxLines: 3,
      animation: true,
    );
  }

  Widget _posterAndTitle({
    required ScreenSize size,
    required Media media,
    required MediaScreenThemeData theme,
    required Widget buttons,
  }) {
    return Padding(
      padding: theme.defaultPadding,
      child: ConstrainedBox(
        constraints: theme.mediaRowConstraints,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _poster(
              height: theme.posterHeight,
              width: theme.posterWidth,
              borderRadius: theme.posterBorderRadius,
              fit: theme.posterFit,
              url: media.poster,
            ),
            Expanded(
              child: _titleAndStatus(
                mainAxisAlignment: theme.titleMainAxisAlignment,
                title: media.title,
                status: media.status,
                titleTextStyle: theme.titleTextStyle,
                statusTextStyle: theme.statusTextStyle,
                padding: theme.titleBoxPadding,
                buttonsVisible: size.isDesktop,
                buttons: buttons,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _titleAndStatus({
    required String title,
    required Status status,
    required TextStyle titleTextStyle,
    required TextStyle statusTextStyle,
    required MainAxisAlignment mainAxisAlignment,
    required EdgeInsets padding,
    required bool buttonsVisible,
    required Widget buttons,
  }) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleTextStyle,
          ),
          VerticalSpace(padding.vertical),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                status == Status.completed
                    ? Icons.done_all_outlined
                    : Icons.schedule_outlined,
                size: MaterialTheme.iconSize,
                color: context.theme.colorScheme.primary,
              ),
              const HorizontalSpace(4),
              Text(
                status.toDisplayString(),
                maxLines: 1,
                style: statusTextStyle,
              )
            ],
          ),
          if (buttonsVisible) VerticalSpace(padding.vertical),
          buttons,
        ],
      ),
    );
  }

  Widget _poster({
    required double height,
    required double width,
    required BorderRadius borderRadius,
    required BoxFit fit,
    required String? url,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: ImageHolder.network(
        height: height,
        width: width,
        url: url,
        fit: fit,
      ),
    );
  }

  Widget _banner(
      {required double height,
      required double width,
      required BoxFit fit,
      required LinearGradient gradient,
      required String? url}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        border: Border.all(
          strokeAlign: -0.050,
          color: gradient.colors.first,
        ),
      ),
      position: DecorationPosition.foreground,
      child: ImageHolder.network(
        height: height,
        width: width,
        url: url,
        fit: fit,
      ),
    );
  }
}

class _MetaData extends StatelessWidget {
  final Media media;
  final ScreenSize size;

  const _MetaData({
    super.key,
    required this.media,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MediaScreenTheme.of(context);

    return Row(
      children: [
        _metaDataItem(
          theme,
          icon: media.format.getFormatIcon(),
          value: media.format.name.captialize().let(
              (it) => size.whenDesktop(() => 'Format: $it', orElse: () => it)),
        ),
        const HorizontalSpace(12),
        _metaDataItem(
          theme,
          icon: Icons.star,
          value: (media.score?.toString() ?? 'N/A').let(
              (it) => size.whenDesktop(() => 'Score: $it', orElse: () => it)),
        ),
      ],
    );
  }

  Widget _metaDataItem(
    MediaScreenThemeData theme, {
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: theme.metaDataIconColor,
        ),
        const HorizontalSpace(8),
        Text(
          value,
          style: theme.metaDataTextStyle,
        )
      ],
    );
  }
}

extension on MediaFormat {
  IconData getFormatIcon() {
    switch (this) {
      case MediaFormat.tvSeries:
      case MediaFormat.movie:
      case MediaFormat.animeMovie:
      case MediaFormat.anime:
      case MediaFormat.asainDrama:
      case MediaFormat.ova:
      case MediaFormat.ona:
      case MediaFormat.cartoon:
      case MediaFormat.documentary:
        return Icons.tv;
      case MediaFormat.webNovel:
      case MediaFormat.novel:
      case MediaFormat.comic:
      case MediaFormat.webtoon:
      case MediaFormat.manga:
      case MediaFormat.lightNovel:
        return Icons.book;
      case MediaFormat.others:
        return Icons.more_horiz;
    }
  }
}

extension on Status {
  String toDisplayString() {
    return name.captialize();
  }
}

class _MediaScreenButtons extends StatelessWidget {
  final ScreenSize size;
  final bool isFavorite;
  final bool isTracked;
  final VoidCallback onPressedFavorite;
  final VoidCallback onPressedTracking;
  final VoidCallback onPressedWebview;

  const _MediaScreenButtons({
    super.key,
    required this.size,
    required this.isFavorite,
    required this.isTracked,
    required this.onPressedFavorite,
    required this.onPressedTracking,
    required this.onPressedWebview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MediaScreenTheme.of(context);

    final enabledButtonStyle = theme.buttonStyle;

    final disabledButtonStyle = theme.unSelectedButtonStyle;

    final spacing = theme.rowSpacing?.let((it) => HorizontalSpace(it));

    final row = Row(
      mainAxisAlignment: theme.buttonMainAxisAlignment,
      children: [
        _button(
          enabled: isFavorite,
          enabledIcon: Icons.favorite,
          disabledIcon: Icons.favorite_border,
          enabledText: 'In library',
          disabledText: 'Add to library',
          onPressed: onPressedFavorite,
          enabledButtonStyle: enabledButtonStyle,
          disabledButtonStyle: disabledButtonStyle,
        ),
        if (spacing != null) spacing,
        _button(
          enabled: isTracked,
          enabledIcon: Icons.done,
          disabledIcon: Icons.sync,
          enabledText: 'Tracked',
          disabledText: 'Tracking',
          onPressed: onPressedTracking,
          enabledButtonStyle: enabledButtonStyle,
          disabledButtonStyle: disabledButtonStyle,
        ),
        if (spacing != null) spacing,
        _button(
          enabled: false,
          enabledIcon: Icons.public_off_outlined,
          disabledIcon: Icons.public_off_outlined,
          enabledText: 'Webview',
          disabledText: 'Webview',
          onPressed: onPressedWebview,
          enabledButtonStyle: enabledButtonStyle,
          disabledButtonStyle: disabledButtonStyle,
        ),
      ],
    );

    return theme.buttonRowConstraints == null
        ? row
        : ConstrainedBox(
            constraints: theme.buttonRowConstraints!,
            child: row,
          );
  }

  Widget _button({
    required bool enabled,
    required ButtonStyle enabledButtonStyle,
    required ButtonStyle disabledButtonStyle,
    required IconData enabledIcon,
    required IconData disabledIcon,
    required String enabledText,
    required String disabledText,
    required VoidCallback onPressed,
  }) {
    final style = enabled ? enabledButtonStyle : disabledButtonStyle;
    final icon = enabled ? enabledIcon : disabledIcon;
    final label = enabled ? enabledText : disabledText;

    final child = Column(
      children: [
        Icon(icon),
        Text(
          label,
          style: style.textStyle?.resolve({}),
        ),
      ],
    );
    return size.isMobile
        ? TextButton(
            style: style,
            onPressed: onPressed,
            child: child,
          )
        : ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: child,
          );
  }
}
