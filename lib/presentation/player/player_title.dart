import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/info/services/episode_cubit.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class PlayerTitle extends StatelessWidget {
  const PlayerTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.5,
      child: InjectKtor.get<InfoScreenCubit>().state.value!.let(
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
          fontSize: MobileFontSize.semiMedium, fontWeight: FontWeight.w600),
      textAlign: TextAlign.left,
    );
  }

  Widget whenEpisodic(InfoPage infoPage) {
    return InjecktorBlocBuilder<EpisodeCubit, int>(
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              InjectKtor.get<EpisodeCubit>()
                  .episode(infoPage.content!)
                  .let((it) => it.name ?? 'Episode ${it.number}'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: MobileFontSize.semiMedium,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            Text(infoPage.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: MobileFontSize.semiMedium,
                    fontWeight: FontWeight.w400)),
          ],
        );
      },
    );
  }
}
