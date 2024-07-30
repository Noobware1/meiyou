import 'package:meiyou/features/details/domain/models/content_list_view_type.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';

class MediaScreenState {
  final Media media;
  final List<MediaContent> contentList;
  final bool isRefreshing;
  final ContentListViewType contentListViewType;

  MediaScreenState({
    required this.media,
    required this.contentList,
    required this.isRefreshing,
    this.contentListViewType = ContentListViewType.list,
  });

  MediaScreenState copyWith({
    Media? media,
    List<MediaContent>? contentList,
    bool? isRefreshing,
    ContentListViewType? contentListViewType,
  }) {
    return MediaScreenState(
      media: media ?? this.media,
      contentList: contentList ?? this.contentList,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      contentListViewType: contentListViewType ?? this.contentListViewType,
    );
  }
}
