import 'package:flutter/material.dart';
import 'package:meiyou/core/helper/media_content_helper.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/details/domain/models/content_list_view_type.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view_theme.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou_extensions_lib/models.dart';

const _gridKey = Key('gridKey');

const _listKey = Key('gridKey');

class ContentListView extends StatelessWidget {
  final ScreenSize size;
  final Media media;
  final List<MediaContent> contentList;
  final ContentListViewType type;
  final bool scrollable;
  final AnimationController progress;
  final VoidCallback onViewTypeChange;
  final EdgeInsets padding;
  final double spacing;
  final bool isRefreshing;

  const ContentListView({
    super.key,
    required this.size,
    required this.media,
    required this.contentList,
    required this.type,
    required this.scrollable,
    required this.progress,
    required this.onViewTypeChange,
    required this.padding,
    required this.spacing,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ContentListViewTheme.of(context);

    final physics = scrollable ? null : const NeverScrollableScrollPhysics();

    if (isRefreshing && contentList.isEmpty) {
      return defaultSizedBox;
    } else if (contentList.isEmpty) {
      return Padding(
        padding: padding,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(spacing),
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
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(spacing),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        media.format.getContentListTitle(),
                        style: theme.titleTextStyle,
                      ),
                    ),
                    IconButton(
                        icon: AnimatedIcon(
                            icon: AnimatedIcons.list_view, progress: progress),
                        onPressed: onViewTypeChange),
                  ]),
            ),
          ),
          VerticalSpace(spacing),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: padding.vertical),
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
                  child: type == ContentListViewType.list
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
          fallackImage: media.bannerOrPoster,
          getDefaultNameCallback: (content) =>
              MediaContentHelper.getDefaultName(content, media),
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
          fallackImage: media.bannerOrPoster,
          getDefaultNameCallback: (content) =>
              MediaContentHelper.getDefaultName(content, media),
        );
      },
      itemCount: contentList.length,
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
