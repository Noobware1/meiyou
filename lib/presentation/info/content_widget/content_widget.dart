import 'package:flutter/material.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/info/content_widget/anime_widget.dart';
import 'package:meiyou/presentation/info/content_widget/lazy_content_widget.dart';
import 'package:meiyou/presentation/info/content_widget/movie_widget.dart';
import 'package:meiyou/presentation/info/content_widget/series_widget.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

// part '../widgets/list_selector_button.dart';

typedef MappedEpisodeChunks = Pair<List<String>, List<Pair<int, int>>>;

extension on Content {
  bool get isEpisodic => isAnime || isSeries;
}

abstract interface class ContentWidget extends Widget {
  abstract final Content content;

  abstract final ContentProgress? contentProgress;

  abstract final void Function() onSelected;

  static void registerWith(Content? content, ContentProgress? progress) {
    unregister();
    if (content == null) return;
    if (content.isAnime) {
      AnimeWidget.registerWith(
          content as Anime, progress is! AnimeProgress ? null : progress);
    } else if (content.isSeries) {
      SeriesWidget.registerWith(
          content as Series, progress is! SeriesProgress ? null : progress);
    }
    return;
  }

  static void unregister() {
    AnimeWidget.unregister();
    SeriesWidget.unregister();
  }

  factory ContentWidget({
    required Content content,
    required ContentProgress? contentProgress,
    required void Function() onSelected,
  }) {
    if (content.isAnime) {
      return AnimeWidget(
          content: content as Anime,
          onSelected: onSelected,
          contentProgress:
              contentProgress is! AnimeProgress ? null : contentProgress);
    } else if (content.isSeries) {
      return SeriesWidget(
          content: content as Series,
          onSelected: onSelected,
          contentProgress:
              contentProgress is! SeriesProgress ? null : contentProgress);
    } else if (content.isMovie) {
      return MovieWidget(
          content: content as Movie,
          onSelected: onSelected,
          contentProgress:
              contentProgress is! MovieProgress ? null : contentProgress);
    } else if (content.isLazy) {
      return LazyContentWidget(content: content as LazyContent);
    } else {
      throw Exception('Unsupported content type');
    }
  }

  static const int maxEpisodeLimit = 26;

  static MappedEpisodeChunks episodesKeyAndIndexes(List<Episode> episodes) {
    const int chunkSize = 26;
    final int numChunks = (episodes.length / chunkSize).ceil();
    final List<String> chunks = List.filled(numChunks, '');
    final List<Pair<int, int>> indexes = List.filled(numChunks, Pair(0, 0));

    for (var i = 0; i < numChunks; i++) {
      final start = i * chunkSize;
      final end = (i * chunkSize + chunkSize > episodes.length
              ? episodes.length
              : i * chunkSize + chunkSize) -
          1;
      chunks[i] =
          '${episodes[start].number ?? (start + 1)}-${episodes[end].number ?? (end + 1)}';
      indexes[i] = Pair(start, end);
    }

    return Pair(chunks, indexes);
  }
}
