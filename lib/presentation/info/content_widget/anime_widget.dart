import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/domain/models/progress.dart';

import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/widgets/episode_list.dart';
import 'package:meiyou/presentation/info/widgets/episode_list_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class AnimeWidget extends StatelessWidget implements ContentWidget {
  const AnimeWidget({
    super.key,
    required this.content,
    required this.contentProgress,
    required this.onSelected,
  });

  static void registerWith(Anime content, AnimeProgress? progress) {
    getIt.registerSingleton(EpisodeNotifer(progress?.lastSeen ?? 0));
    getIt.registerSingleton(EpisodeListSelectorNotifer(
        index: progress?.episodeListIndex ?? 0,
        episodeNotifer: getIt.get(),
        episodes: content.episodes));
  }

  static void unregister() {
    getIt.unregisterIfRegistered<EpisodeNotifer>();
    getIt.unregisterIfRegistered<EpisodeListSelectorNotifer>();
  }

  @override
  final Anime content;

  @override
  final AnimeProgress? contentProgress;

  @override
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return EpisodesList(
        episodes: content.episodes,
        progress: contentProgress?.progress,
        onSelected: onSelected);
  }
}
