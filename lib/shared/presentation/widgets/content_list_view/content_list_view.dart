import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/helper/media_content_helper.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/details/domain/models/content_list_view_type.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view_theme.dart';
import 'package:meiyou/shared/presentation/widgets/dialogs/list_dialog.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

const _gridKey = Key('gridKey');

const _listKey = Key('gridKey');

class ContentListView extends StatefulWidget {
  final ScreenSize size;
  final Media media;
  final SeasonGroupedContent groupedContent;
  final ContentListViewType type;
  final bool scrollable;
  final EdgeInsets padding;
  final double spacing;
  final bool isRefreshing;
  final void Function(ContentListViewType) onViewTypeChange;
  final void Function(MediaContent) onContentSelected;

  const ContentListView({
    super.key,
    required this.size,
    required this.media,
    required this.groupedContent,
    required this.type,
    required this.scrollable,
    required this.onViewTypeChange,
    required this.padding,
    required this.spacing,
    required this.isRefreshing,
    required this.onContentSelected,
  });

  @override
  State<ContentListView> createState() => _ContentListViewState();
}

class _ContentListViewState extends State<ContentListView>
    with SingleTickerProviderStateMixin {
  late final AnimationController progressController;
  late ContentListViewType type;
  int season = -1;
  String contentListKey = '';
  List<MediaContent> contentList = [];

  @override
  void initState() {
    super.initState();
    progressController =
        AnimationController(vsync: this, duration: Durations.long1);
    type = widget.type;
    _setData();
  }

  @override
  void didUpdateWidget(covariant ContentListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groupedContent != widget.groupedContent) {
      _setData();
    }
  }

  void _setData() {
    if (widget.groupedContent.isNotEmpty) {
      season = widget.groupedContent.keys.first;
      contentListKey = widget.groupedContent[season]!.keys.first;
      contentList = widget.groupedContent[season]![contentListKey]!;
    }
  }

  void _onViewTypeChange() {
    if (type == ContentListViewType.list) {
      progressController.forward();
      type = ContentListViewType.grid;
    } else {
      progressController.reverse();
      type = ContentListViewType.list;
    }
    widget.onViewTypeChange(type);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ContentListViewTheme.of(context);

    final physics =
        widget.scrollable ? null : const NeverScrollableScrollPhysics();

    if (widget.isRefreshing && widget.groupedContent.isEmpty) {
      return defaultSizedBox;
    } else if (widget.groupedContent.isEmpty) {
      return Padding(
        padding: widget.padding,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(widget.spacing),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'No content available',
                style: theme.titleTextStyle,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(widget.spacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            widget.media.format.getContentListTitle(),
                            style: theme.titleTextStyle,
                          ),
                        ),
                        IconButton(
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.list_view,
                              progress: progressController,
                            ),
                            onPressed: _onViewTypeChange),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.groupedContent.length > 1)
                        FilledButton(
                          onPressed: () {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) => SeasonSelector(
                                selectedSeason: season,
                                seasons: widget.groupedContent.keys.toList(),
                                onSelected: (newSeason) {
                                  setState(() {
                                    season = newSeason;
                                    contentListKey = widget
                                        .groupedContent[season]!.keys.first;
                                    contentList = widget.groupedContent[
                                        season]![contentListKey]!;
                                  });
                                  context.pop();
                                },
                              ),
                            );
                          },
                          child: Text('Season $season'),
                        ),
                      if (widget.groupedContent[season]!.length > 1)
                        FilledButton.icon(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) => ContentListSelector(
                                selected: contentListKey,
                                keys: widget.groupedContent[season]!.keys
                                    .toList(),
                                onSelected: (newContentListKey) {
                                  setState(() {
                                    contentListKey = newContentListKey;
                                    contentList = widget.groupedContent[
                                        season]![contentListKey]!;
                                  });
                                  context.pop();
                                },
                              ),
                            );
                          },
                          label: Text(contentListKey),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          VerticalSpace(widget.spacing),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: widget.padding.vertical),
              child: MediaQuery.removePadding(
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
                  child: widget.type == ContentListViewType.list
                      ? _list(physics: physics)
                      : _grid(
                          physics: physics,
                          mainAxisExtent: theme.mainAxisExtent,
                          crossAxisSpacing: theme.crossAxisSpacing,
                          mainAxisSpacing: theme.mainAxisSpacing,
                          maxCrossAxisExtent: theme.maxCrossAxisExtent,
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _list({
    required ScrollPhysics? physics,
  }) {
    return ListView.builder(
      key: _listKey,
      physics: physics,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final content = contentList[index];
        return ContentHolderList(
          content: content,
          fallackImage: widget.media.bannerOrPoster,
          getDefaultNameCallback: (content) =>
              MediaContentHelper.getDefaultName(content, widget.media),
          onPressed: widget.onContentSelected,
        );
      },
      itemCount: contentList.length,
    );
  }

  Widget _grid({
    required ScrollPhysics? physics,
    required double mainAxisExtent,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
    required double maxCrossAxisExtent,
  }) {
    return GridView.builder(
      key: _gridKey,
      physics: physics,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: (context, index) {
        final content = contentList[index];
        return ContentHolderGrid(
          content: content,
          fallackImage: widget.media.bannerOrPoster,
          getDefaultNameCallback: (content) =>
              MediaContentHelper.getDefaultName(content, widget.media),
          onPressed: widget.onContentSelected,
        );
      },
      itemCount: contentList.length,
    );
  }
}

class ContentListSelector extends StatelessWidget {
  final void Function(String) onSelected;
  final String selected;
  final List<String> keys;
  const ContentListSelector({
    super.key,
    required this.keys,
    required this.onSelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListDailog(
      keys: keys,
      values: keys,
      onSelected: onSelected,
      selected: selected,
    );
  }
}

class SeasonSelector extends StatelessWidget {
  final void Function(int) onSelected;
  final List<int> seasons;
  final int selectedSeason;
  const SeasonSelector({
    super.key,
    required this.onSelected,
    required this.seasons,
    required this.selectedSeason,
  });

  @override
  Widget build(BuildContext context) {
    return ListDailog(
      keys: seasons.mapList((season) => 'Season $season'),
      values: seasons,
      onSelected: onSelected,
      selected: selectedSeason,
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
