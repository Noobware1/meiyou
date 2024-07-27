import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/details.dart';
import 'package:meiyou/features/details/presentation/media_screen_theme_data.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
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

class _MediaScreenState extends State<MediaScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final details = getDetails();
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
              Padding(
                padding: theme.defaultPadding,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!size.isDesktop)
                          const VerticalSpace(MaterialTheme.spacing),
                        mobileButtons,
                        const VerticalSpace(MaterialTheme.spacing),
                        description(
                            size: size,
                            theme: theme,
                            description:
                                details.description ?? 'No description'),
                        if (details.genres.isNotEmptyOrNull) ...[
                          const VerticalSpace(MaterialTheme.spacing),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: MaterialTheme.spacing,
                            runSpacing: MaterialTheme.spacing,
                            children: details.genres!
                                .mapList((e) => Chip(label: Text(e))),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              )
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
  }) {
    final child = ExpandableText(
      description,
      expandText: 'Read more',
      collapseText: 'Read less',
      style: theme.descriptionTextStyle,
      maxLines: 3,
      animation: true,
    );
    if (size.isDesktop && theme.descriptionLabelTextStyle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: theme.descriptionLabelTextStyle!,
          ),
          const VerticalSpace(MaterialTheme.spacing),
          child,
        ],
      );
    }

    return child;
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
                '${status.toDisplayString()} · KickAssAnime',
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
