import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// import 'package:meiyou/a.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/details.dart';
import 'package:meiyou/features/details/presentation/media_screen_theme_data.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaScreen extends StatefulWidget {
  // final int mediaDetailsId;
  const MediaScreen({
    super.key,
    //  required this.mediaDetailsId
  });

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  ContentListType type = ContentListType.list;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.long1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = getDetails();
    final contentList = getContentList();
    return ResponsiveBuilder(builder: (context, constraints, size) {
      final theme = MediaScreenThemeData.forSize(context, constraints, size);

      final desktopButtons = mainButtons(
        size: ScreenSize.desktop,
        theme: theme,
        visible: size.isDesktop,
        onPressedLibrary: () {},
        isInLibrary: true,
        onPressedTracking: () {},
        isTracking: false,
        onPressedWebview: () {},
      );

      final mobileButtons = mainButtons(
        size: ScreenSize.mobile,
        theme: theme,
        visible: !size.isDesktop,
        onPressedLibrary: () {},
        isInLibrary: true,
        onPressedTracking: () {},
        isTracking: false,
        onPressedWebview: () {},
      );

      return Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Durations.short4,
                height: theme.stackHeight,
                child: Stack(
                  children: [
                    VerticalSpace(theme.stackHeight),
                    _banner(
                      height: theme.bannerHeight,
                      width: theme.bannerWidth,
                      fit: theme.bannerFit,
                      gradient: theme.bannerGradient,
                      url: details.bannerOrPoster,
                    ),
                    Positioned(
                      bottom: theme.posterPosition,
                      child: _posterAndTitle(
                        media: details,
                        theme: theme,
                        size: size,
                        buttons: desktopButtons,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpace(theme.spacing),
              Padding(
                padding: theme.defaultPadding,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: theme.spacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!size.isDesktop) VerticalSpace(theme.spacing),
                        mobileButtons,
                        VerticalSpace(theme.spacing),
                        _MetaData(
                          media: details,
                          theme: theme,
                          size: size,
                        ),
                        VerticalSpace(theme.spacing),
                        description(
                          size: size,
                          theme: theme,
                          description: details.description ?? 'No description',
                          otherTitles: details.otherTitles,
                        ),
                        if (details.genres.isNotEmptyOrNull) ...[
                          VerticalSpace(theme.spacing),
                          ChipTheme(
                            data: theme.genreChipTheme,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 8,
                              children: details.genres!.mapList(
                                (e) => FilterChip(
                                  onSelected: (_) => {},
                                  visualDensity: theme.genreVisualDensity,
                                  label: Text(e),
                                ),
                              ),
                            ),
                          ),
                        ],
                        VerticalSpace(theme.spacing),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSpace(theme.spacing),
              Padding(
                padding: theme.defaultPadding,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing, vertical: theme.spacing),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Episodes',
                            style: context.theme.textTheme.titleLarge,
                          ),
                          IconButton(
                              icon: AnimatedIcon(
                                  icon: AnimatedIcons.list_view,
                                  progress: _animationController),
                              onPressed: () {
                                setState(() {
                                  if (type == ContentListType.list) {
                                    _animationController.forward();
                                    type = ContentListType.grid;
                                  } else {
                                    _animationController.reverse();
                                    type = ContentListType.list;
                                  }
                                });
                              }),
                        ]),
                  ),
                ),
              ),
              VerticalSpace(theme.spacing),
              Flexible(
                child: Padding(
                  padding: theme.defaultPadding,
                  child: ContentList(
                    type: type,
                    size: size,
                    media: details,
                    contentList: contentList,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget mainButtons({
    required bool visible,
    required ScreenSize size,
    required MediaScreenThemeData theme,
    required VoidCallback onPressedLibrary,
    required bool isInLibrary,
    required VoidCallback onPressedTracking,
    required bool isTracking,
    required VoidCallback onPressedWebview,
  }) {
    return Visibility(
      maintainAnimation: true,
      maintainState: true,
      maintainSemantics: false,
      maintainSize: false,
      maintainInteractivity: false,
      visible: visible,
      child: _MediaScreenButtons(
        theme: theme,
        size: size,
        isInLibrary: isInLibrary,
        onPressedLibrary: onPressedLibrary,
        isTracking: isTracking,
        onPressedTracking: onPressedTracking,
        onPressedWebview: onPressedWebview,
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

class ContentList extends StatefulWidget {
  final ScreenSize size;
  final Media media;
  final List<IMediaContent> contentList;
  final ContentListType type;
  final bool scrollable;
  const ContentList({
    super.key,
    required this.media,
    required this.size,
    required this.contentList,
    this.scrollable = false,
    this.type = ContentListType.list,
  });

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  Media get media => widget.media;

  List<IMediaContent> get contentList => widget.contentList;

  bool get scrollable => widget.scrollable;

  ContentListType get type => widget.type;

  Key get gridKey => const Key('gridKey');

  Key get listKey => const Key('gridKey');

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        duration: Durations.long1,
        child: type == ContentListType.list ? _list() : _grid(),
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
      key: listKey,
      physics: !scrollable ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final content = contentList[index];
        return ContentHolderList(
          content: content,
        );
      },
      itemCount: contentList.length,
    );
  }

  Widget _grid() {
    return GridView.builder(
      key: gridKey,
      physics: !scrollable ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        mainAxisExtent: widget.size
            .when(mobile: () => 170, tablet: () => 210, desktop: () => 250),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final content = contentList[index];
        return ContentHolderGrid(
          content: content,
        );
      },
      itemCount: contentList.length,
    );
  }
}

enum ContentListType {
  list,
  grid,
}

class _MetaData extends StatelessWidget {
  final MediaScreenThemeData theme;
  final Media media;
  final ScreenSize size;

  const _MetaData({
    super.key,
    required this.theme,
    required this.media,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _metaDataItem(
          context,
          icon: media.format.getFormatIcon(),
          value: media.format.name.captialize().let(
              (it) => size.whenDesktop(() => 'Format: $it', orElse: () => it)),
        ),
        const HorizontalSpace(12),
        _metaDataItem(
          context,
          icon: Icons.star,
          value: (media.score?.toString() ?? 'N/A').let(
              (it) => size.whenDesktop(() => 'Score: $it', orElse: () => it)),
        ),
      ],
    );
  }

  Widget _metaDataItem(
    BuildContext context, {
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
  String getContentListTitle() {
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
        return 'Watch';
      case MediaFormat.webNovel:
      case MediaFormat.novel:
      case MediaFormat.comic:
      case MediaFormat.webtoon:
      case MediaFormat.manga:
      case MediaFormat.lightNovel:
        return 'Read';
      case MediaFormat.others:
        return 'Content';
    }
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
  final MediaScreenThemeData theme;
  final ScreenSize size;
  final VoidCallback onPressedLibrary;
  final bool isInLibrary;
  final VoidCallback onPressedTracking;
  final bool isTracking;
  final VoidCallback onPressedWebview;

  const _MediaScreenButtons({
    super.key,
    required this.theme,
    required this.isInLibrary,
    required this.onPressedLibrary,
    required this.isTracking,
    required this.onPressedTracking,
    required this.onPressedWebview,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = theme.rowSpacing?.let((it) => HorizontalSpace(it));

    final row = Row(
      mainAxisAlignment: theme.buttonMainAxisAlignment,
      children: [
        _button(
          selectedIcon: Icons.favorite,
          unSelectedIcon: Icons.favorite_outline,
          selectedLabel: 'In library',
          unselectedLabel: 'Add to library',
          enabled: isInLibrary,
          onPressed: onPressedLibrary,
        ),
        if (spacing != null) spacing,
        _button(
          selectedIcon: Icons.done,
          unSelectedIcon: Icons.sync,
          selectedLabel: 'Tracked',
          unselectedLabel: 'Tracking',
          enabled: isTracking,
          onPressed: onPressedTracking,
        ),
        if (spacing != null) spacing,
        _button(
          selectedIcon: Icons.public,
          unSelectedIcon: Icons.public,
          selectedLabel: 'Webview',
          unselectedLabel: 'Webview',
          enabled: false,
          onPressed: onPressedWebview,
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
    IconData? selectedIcon,
    IconData? unSelectedIcon,
    String? unselectedLabel,
    String? selectedLabel,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final style = enabled ? theme.buttonStyle : theme.unSelectedButtonStyle;
    final icon = !enabled ? unSelectedIcon : selectedIcon;
    final label = !enabled ? unselectedLabel : selectedLabel;
    final child = Column(
      children: [
        Icon(icon),
        Text(
          label!,
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
