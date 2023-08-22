import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/generate_episode_chunk.dart';
import 'package:streamify/notifers/episodes_notifer.dart';
import 'package:streamify/notifers/watch_notifer.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/widgets/episode_holder.dart';
import 'package:streamify/widgets/episode_selector.dart';

class EpisodeView extends StatelessWidget {
  final LoadResponse loadResponse;

  const EpisodeView({super.key, required this.loadResponse});

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<MediaDetails>(context, listen: false);
    final metaEpisode = Provider.of<Map<String, List<Episode>>?>(context);

    return Consumer<WatchViewNotifer>(builder: (context, value, child) {
      final String? key;
      if (metaEpisode?.keys.first == '0') {
        key = '0';
      } else if (metaEpisode?.containsKey(value.season?.number) == true) {
        key = value.season?.number;
      } else {
        key = null;
      }
      final selectedEpisode =
          loadResponse.generateEpisodeResponse(media, metaEpisode?[key] ?? []);

      final episodeRows = GenerateEpisodesChunks.buildEpisodesResponse(
          selectedEpisode, selectedEpisode.length);

      return ChangeNotifierProvider(
          create: (context) => EpisodeViewNotifer(episodes: episodeRows),
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: EpisodeSelector(),
                ),
                addVerticalSpace(30),
                Consumer<EpisodeViewNotifer>(builder: (context, value, child) {
                  return Column(
                      children: List.generate(
                    value.selectedEp.length,
                    (index) {
                      final ep = value.selectedEp;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: EpisodeHolder(
                          onTap: () {},
                          number: ep[index].number,
                          title: ep[index].title!,
                          desc: ep[index].desc,
                          rated: ep[index].rated,
                          thumbnail: ep[index].thumbnail,
                        ),
                      );
                    },
                  ));
                })
              ],
            );
          });
    });
  }
}
