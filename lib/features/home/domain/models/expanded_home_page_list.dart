import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/src/result.dart';

class ExpandedHomePageList {
  final String title;
  final List<Media> mediaList;
  final bool horizontalImages;
  final int currentPage;
  final bool hasNext;

  const ExpandedHomePageList({
    required this.title,
    required this.mediaList,
    required this.horizontalImages,
    required this.currentPage,
    required this.hasNext,
  });

  ExpandedHomePageList copyWith({
    String? title,
    List<Media>? mediaList,
    bool? horizontalImages,
    int? currentPage,
    bool? hasNext,
  }) {
    return ExpandedHomePageList(
      title: title ?? this.title,
      mediaList: mediaList ?? this.mediaList,
      horizontalImages: horizontalImages ?? this.horizontalImages,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
