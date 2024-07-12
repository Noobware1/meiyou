import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';

class ContinueFrom extends StatelessWidget {
  final InfoPage infoPage;
  // final ContentProgress? progress;
  final VoidCallback onPressed;

  const ContinueFrom(
      {super.key,
      required this.infoPage,
      // required this.progress,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (infoPage.content!.isLazy) return defaultSizedBox;

    final String title;
    final String? subtitle;
    final String? image;

    if (infoPage.content!.isSeries || infoPage.content!.isAnime) {
      final episode = getIt.get<EpisodeNotifer>().episode(infoPage.content!);
      title = 'Episode ${episode.number}';
      subtitle = episode.name;
      image = episode.image;
    } else {
      title = infoPage.name;
      subtitle = null;
      image = null;
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      // onTap: onPressed,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),

      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ImageHolder(
                height: 80,
                width: context.width,
                fit: BoxFit.cover,
                imageUrl: image ?? infoPage.bannerImage ?? infoPage.posterImage,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue : $title',
                            style: const TextStyle(
                                fontSize: MobileFontSize.normal,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: MobileFontSize.normal,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Material(
                type: MaterialType.button,
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                ))
          ],
        ),
      ),
    );
  }
}
