import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/presentation/widgets/poster_view/poster_view_theme_data.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou_extensions_lib/models.dart';

class PosterView extends StatefulWidget {
  final String label;
  final List<Media> mediaList;
  final PosterViewThemeData? theme;
  final void Function(Media)? onSelected;
  final void Function(Media)? onLongPressed;
  final void Function(TapDownDetails, Media)? onSecondaryTapDown;
  final ScrollController? scrollController;
  const PosterView({
    super.key,
    required this.label,
    required this.mediaList,
    this.theme,
    this.onSelected,
    this.onLongPressed,
    this.onSecondaryTapDown,
    this.scrollController,
  });

  @override
  State<PosterView> createState() => _PosterViewState();
}

class _PosterViewState extends State<PosterView> {
  bool isInitialized = false;
  late final ScrollController? scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInitialized) return;
    if (!context.theme.platform.isMobile) {
      scrollController = widget.scrollController ?? ScrollController();
    } else {
      scrollController = widget.scrollController;
    }
    isInitialized = true;
  }

  List<Media> get mediaList => widget.mediaList;

  PosterViewThemeData get theme =>
      widget.theme ?? PosterViewThemeData.getDefault(context);

  @override
  Widget build(BuildContext context) {
    final borderRadius = theme.borderRadius;
    final platform = context.theme.platform;

    final isMobile = platform.isMobile;

    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      final width = constraints.maxWidth;

      final labelBoxHeight = theme.labelBoxHeight;
      final posterSize = theme.getPosterSizeForSize(screenSize);
      final titleTextStyle = theme.getTitleTextStyleForSize(screenSize);
      final labelTextStyle = theme.getLabelTextStyleForSize(screenSize);
      final titleBoxHeight =
          titleTextStyle.fontSize! * titleTextStyle.height! * 2.2;
      var listViewHeight =
          posterSize.height + titleBoxHeight + theme.titleSpacing;

      final increaseValue = theme.sizeIncreaseValue;

      if (!platform.isMobile) {
        listViewHeight += increaseValue;
      }

      final boxHeight = listViewHeight + labelBoxHeight;
      final titleSpacing = theme.titleSpacing;
      final titlePadding = theme.titlePadding;

      return AnimatedContainer(
        duration: Durations.short3,
        height: boxHeight,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: labelBoxHeight,
                padding: theme.contentPadding,
                alignment: Alignment.centerLeft,
                child: Text(widget.label, style: labelTextStyle),
              ),
            ),
            AnimatedContainer(
              height: listViewHeight,
              width: width,
              duration: Durations.short3,
              child: _wrapWithSCrollBar(
                platform: platform,
                controller: scrollController,
                child: ListView.separated(
                  key: widget.key,
                  controller: scrollController,
                  padding: theme.contentPadding,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final preview = mediaList[index];
                    if (isMobile) {
                      return _Poster(
                        preview: preview,
                        height: posterSize.height,
                        width: posterSize.width,
                        borderRadius: borderRadius,
                        titleTextStyle: titleTextStyle,
                        titleSpacing: titleSpacing,
                        titlePadding: titlePadding,
                        onSelected: widget.onSelected,
                        onLongPressed: widget.onLongPressed,
                      );
                    }
                    return _PosterDesktop(
                      preview: preview,
                      height: posterSize.height,
                      width: posterSize.width,
                      borderRadius: borderRadius,
                      titleTextStyle: titleTextStyle,
                      titleSpacing: titleSpacing,
                      titlePadding: titlePadding,
                      increaseValue: increaseValue,
                      onSelected: widget.onSelected,
                      onLongPressed: widget.onLongPressed,
                      onSecondaryTapDown: widget.onSecondaryTapDown,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return HorizontalSpace(theme.spacing);
                  },
                  itemCount: mediaList.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _wrapWithSCrollBar(
      {required TargetPlatform platform,
      required ScrollController? controller,
      required Widget child}) {
    if (platform.isMobile) {
      return child;
    }
    return Scrollbar(
      controller: controller,
      interactive: true,
      child: child,
    );
  }
}

class _Poster extends StatelessWidget {
  final Media preview;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final TextStyle titleTextStyle;
  final double titleSpacing;
  final EdgeInsets titlePadding;
  final void Function(Media)? onSelected;
  final void Function(Media)? onLongPressed;
  const _Poster({
    super.key,
    required this.preview,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.titleTextStyle,
    required this.titleSpacing,
    required this.titlePadding,
    required this.onSelected,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [
          ClipRRect(
              borderRadius: borderRadius,
              child: ImageHolder.network(
                url: preview.poster,
                fit: BoxFit.fill,
                height: height,
                width: width,
              )),
          VerticalSpace(titleSpacing),
          GestureDetector(
            onTap: onSelected == null ? null : () => onSelected!(preview),
            onLongPress: onSelected == null ? null : () => onSelected!(preview),
            child: Container(
              padding: titlePadding,
              width: width,
              child: Text(
                preview.title,
                style: titleTextStyle,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ]),
        Material(
          borderRadius: borderRadius,
          type: MaterialType.button,
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: onSelected == null ? null : () => onSelected!(preview),
            onLongPress:
                onLongPressed == null ? null : () => onLongPressed!(preview),
            child: SizedBox(
              height: height,
              width: width,
            ),
          ),
        ),
      ],
    );
  }
}

class _PosterDesktop extends StatefulWidget {
  final Media preview;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final void Function(Media)? onSelected;
  final void Function(Media)? onLongPressed;
  final void Function(TapDownDetails, Media)? onSecondaryTapDown;
  final TextStyle titleTextStyle;
  final double titleSpacing;
  final EdgeInsets titlePadding;
  final double increaseValue;
  const _PosterDesktop({
    super.key,
    required this.preview,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.titleTextStyle,
    required this.titleSpacing,
    required this.titlePadding,
    required this.increaseValue,
    required this.onSelected,
    required this.onLongPressed,
    required this.onSecondaryTapDown,
  });

  @override
  State<_PosterDesktop> createState() => __PosterState();
}

class __PosterState extends State<_PosterDesktop> {
  late final WidgetStatesController statesController;
  late double posterHeight;
  late double posterWidth;

  @override
  void initState() {
    super.initState();
    statesController = WidgetStatesController();
    posterHeight = widget.height;
    posterWidth = widget.width;
    statesController.addListener(() {
      final value = statesController.value;
      if (value.contains(WidgetState.hovered) ||
          value.contains(WidgetState.focused)) {
        setState(() {
          posterHeight = widget.height + widget.increaseValue;
          posterWidth = widget.width + widget.increaseValue;
        });
      } else if (posterHeight != widget.height || posterWidth != widget.width) {
        setState(() {
          posterHeight = widget.height;
          posterWidth = widget.width;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _PosterDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.height != oldWidget.height || widget.width != oldWidget.width) {
      posterHeight = widget.height;
      posterWidth = widget.width;
    }
  }

  @override
  void dispose() {
    statesController.dispose();
    super.dispose();
  }

  double exitDy = 0.0;

  @override
  Widget build(BuildContext context) {
    final preview = widget.preview;
    final borderRadius = widget.borderRadius;
    final onSelected = widget.onSelected;

    return Stack(
      children: [
        Column(children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: AnimatedContainer(
              duration: Durations.short3,
              height: posterHeight,
              width: posterWidth,
              child: ImageHolder.network(
                url: preview.poster,
                fit: BoxFit.fill,
                height: posterHeight,
                width: posterWidth,
              ),
            ),
          ),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                statesController.update(WidgetState.hovered, true);
              },
              onExit: (event) {
                statesController.update(WidgetState.hovered, false);
              },
              child: GestureDetector(
                onTap: onSelected == null ? null : () => onSelected(preview),
                onLongPress:
                    onSelected == null ? null : () => onSelected(preview),
                child: Container(
                  padding: widget.titlePadding.copyWith(
                      top: widget.titlePadding.top + widget.titleSpacing),
                  width: posterWidth,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Text(
                      preview.title,
                      style: widget.titleTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
        Material(
          borderRadius: borderRadius,
          type: MaterialType.button,
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            statesController: statesController,
            onTap: onSelected == null ? null : () => onSelected(preview),
            onLongPress: widget.onLongPressed == null
                ? null
                : () => widget.onLongPressed!(preview),
            onSecondaryTapDown: widget.onSecondaryTapDown == null
                ? null
                : (details) => widget.onSecondaryTapDown!(details, preview),
            child: SizedBox(
              height: posterHeight,
              width: posterWidth,
            ),
          ),
        ),
      ],
    );
  }
}
