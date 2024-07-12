import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class PlayerTitle extends StatelessWidget {
  const PlayerTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.5,
      child: getIt.get<InfoScreenNotifer>().state.value!.let(
            (it) => it.content!.when(
              anime: (_) {
                return whenEpisodic(it);
              },
              series: (_) {
                return whenEpisodic(it);
              },
              movie: (_) {
                return whenMovie(it);
              },
              lazy: (_) => throw Exception(),
            ),
          ),
    );
  }

  Widget whenMovie(InfoPage infoPage) {
    return Text(
      infoPage.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontSize: MobileFontSize.normal,
          fontWeight: FontWeight.w600,
          color: Colors.white),
      textAlign: TextAlign.left,
    );
  }

  Widget whenEpisodic(InfoPage infoPage) {
    return GetItListenableBuilder<EpisodeNotifer, int>(
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getIt
                  .get<EpisodeNotifer>()
                  .episode(infoPage.content!)
                  .let((it) => it.name ?? 'Episode ${it.number}'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: MobileFontSize.normal,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
            Text(infoPage.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: MobileFontSize.small,
                    fontWeight: FontWeight.w400)),
          ],
        );
      },
    );
  }
}
