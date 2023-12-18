import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_extracted_media_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_episode_usecase.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/season_cubit.dart';
import 'package:meiyou/presentation/providers/player_dependencies.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/episode_holder.dart';
import 'package:meiyou/presentation/widgets/selector_dilaog_box.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/models.dart';

class TvSeriesView extends StatelessWidget {
  const TvSeriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaDetails = context.repository<MediaDetails>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BlocBuilder<SeasonCubit, SeasonData>(builder: (context, state) {
        return ElevatedButton(
            style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                    Size(isMobile ? 100 : 120, isMobile ? 40 : 50)),
                maximumSize: MaterialStatePropertyAll(
                    Size(isMobile ? 120 : 140, isMobile ? 40 : 50)),
                elevation: const MaterialStatePropertyAll(4.0),
                surfaceTintColor: MaterialStatePropertyAll(
                    context.theme.colorScheme.tertiary),
                backgroundColor: MaterialStatePropertyAll(
                    context.theme.colorScheme.tertiary),
                textStyle: MaterialStatePropertyAll(TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w500))),
            onPressed: () {
              showSeasonSelector(context,
                  seasonCubit: context.bloc<SeasonCubit>(),
                  data: (mediaDetails.mediaItem as TvSeries).data);
            },
            child: Text(
              state.name ?? 'Season ${state.season}',
              style: TextStyle(color: context.theme.colorScheme.onSurface),
            ));
      }),
      addVerticalSpace(isMobile ? 10 : 30),
      BlocBuilder<EpisodesCubit, Map<String, List<Episode>>>(
          builder: (context, state) {
        if (state.keys.length == 1) return defaultSizedBox;
        return Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 10 : 30),
          child: EpisodesSelector(episodes: state.keys.toList()),
        );
      }),
      addVerticalSpace(isMobile ? 10 : 30),
      BlocBuilder<EpisodesCubit, Map<String, List<Episode>>>(
          builder: (context, seasonAndEpisodes) {
        return BlocBuilder<EpisodesSelectorCubit, String>(
          builder: (context, key) {
            return Column(
                // separatorBuilder: (context, index) => addVerticalSpace(10),
                children: seasonAndEpisodes[key]!.mapWithIndex(
                    (index, it) => _ToEpsiode(index: index, episode: it)));
          },
        );
      }),
    ]);
  }

  Future showSeasonSelector(
    BuildContext context, {
    required SeasonCubit seasonCubit,
    required List<SeasonList> data,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            // insetPadding: EdgeInsets.all(40),
            elevation: 10,

            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 300, maxHeight: 280, minHeight: 20),
              // color: Colors.red,
              child: ListView(shrinkWrap: true, children: [
                addVerticalSpace(10),
                ...List.generate(data.length, (index) {
                  return ArrowButton(
                    isSelected: seasonCubit.state == data[index].season,
                    onTap: () {
                      if (seasonCubit.state != data[index].season) {
                        seasonCubit.updateSeason(data[index]);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                        data[index].season.name ??
                            'Season ${data[index].season.season}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  );
                }),
                addVerticalSpace(10)
              ]),
            ),
          );
        });
  }
}

class AnimeView extends StatelessWidget {
  const AnimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<EpisodesCubit, Map<String, List<Episode>>>(
            builder: (context, state) {
          if (state.keys.length == 1) return defaultSizedBox;
          return Padding(
            padding: EdgeInsets.only(top: isMobile ? 10 : 30),
            child: EpisodesSelector(episodes: state.keys.toList()),
          );
        }),
        addVerticalSpace(isMobile ? 10 : 30),
        BlocBuilder<EpisodesCubit, Map<String, List<Episode>>>(
            builder: (context, seasonAndEpisodes) {
          return BlocBuilder<EpisodesSelectorCubit, String>(
            builder: (context, key) {
              return Column(
                  // separatorBuilder: (context, index) => addVerticalSpace(10),
                  children: seasonAndEpisodes[key]!.mapWithIndex(
                      (index, it) => _ToEpsiode(index: index, episode: it)));
            },
          );
        }),
      ],
    );
  }
}

class MovieView extends StatelessWidget {
  const MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaDetails = context.repository<MediaDetails>();
    final movie = mediaDetails.mediaItem as Movie;
    return EpisodeHolder(
      onTap: () {},
      number: 0,
      desc: movie.description ?? mediaDetails.description,
      rated: mediaDetails.rating,
      thumbnail: movie.posterImage ??
          mediaDetails.bannerImage ??
          mediaDetails.posterImage,
      title: mediaDetails.name,
    );
  }
}

class _ToEpsiode extends StatelessWidget {
  final Episode episode;
  final int index;
  const _ToEpsiode({required this.episode, required this.index});

  @override
  Widget build(BuildContext context) {
    final mediaDetails = context.repository<MediaDetails>();
    final number = episode.episode ?? index + 1;
    final thumbnail = episode.posterImage ??
        mediaDetails.bannerImage ??
        mediaDetails.posterImage;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: EpisodeHolder(
        onTap: () {
          if (context.currentRoutePath.toString().endsWith('player')) {
            context
                .tryRepository<VideoPlayerRepositoryUseCases>()
                ?.changeEpisodeUseCase(ChangeEpisodeUseCaseParams(
                    context: context, episode: episode, index: index));
          } else {
            context.push(
              Routes.reslovePlayerRoute(context),
              extra: PlayerDependenciesProvider.createFromContext(
                context,
                LoadExtractedMediaStreamUseCaseParams(episode.data),
                index,
              ),
            );
          }
        },
        number: number,
        desc: episode.description,
        thumbnail: thumbnail,
        title: episode.name ?? 'Episode $number',
      ),
    );
  }
}

class EpisodesSelector extends StatefulWidget {
  const EpisodesSelector({
    super.key,
    required this.episodes,
  });

  final List<String> episodes;
  // final bool showScrollBar;

  @override
  State<EpisodesSelector> createState() => _EpisodesSelectorState();
}

class _EpisodesSelectorState extends State<EpisodesSelector> {
  late final ScrollController? _controller;

  @override
  void initState() {
    if (!isMobile) {
      _controller = ScrollController();
    } else {
      _controller = null;
    }
    super.initState();
  }

  Widget _buildSrollBar({required Widget child}) {
    if (isMobile) return child;
    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        thumbColor: MaterialStatePropertyAll(Colors.grey),
      ),
      child: Scrollbar(
        controller: _controller,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: context.screenWidth,
      child: _buildSrollBar(
        child: BlocBuilder<EpisodesSelectorCubit, String>(
          builder: (context, state) {
            return ListView.separated(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, i) => addHorizontalSpace(10),
                itemCount: widget.episodes.length,
                itemBuilder: (context, index) {
                  final isNotSelected =
                      context.bloc<EpisodesSelectorCubit>().state !=
                          widget.episodes[index];
                  return Material(
                    color: isNotSelected
                        ? context.theme.colorScheme.background
                        : context.theme.colorScheme.primary,
                    animationDuration: animationDuration,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      splashColor: context.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        if (isNotSelected) {
                          context
                              .bloc<EpisodesSelectorCubit>()
                              .updateKey(widget.episodes[index]);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: isNotSelected
                                  ? Colors.grey
                                  : context.theme.colorScheme.primary,
                              width: 2),
                        ),
                        child: Text(widget.episodes[index],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}


// Widget _toEpisodeForGrid(BuildContext context, int index, Episode episode,
//     MediaDetails mediaDetails, bool isMobile) {
//   final number = episode.episode ?? index + 1;
//    Stack(
//     fit: StackFit.passthrough,
//     children: [
//       ImageHolder(
//         imageUrl: episode.posterImage ??
//             mediaDetails.bannerImage ??
//             mediaDetails.posterImage,
//         height: isMobile ? 100 : 150,
//         width: isMobile ? 170 : 200,
//         fit: BoxFit.cover,
//       ),
//       const Positioned(
//         bottom: 0,
//         right: 0,
//         left: 0,
//         child: DrawGradient(
//             height: 100,
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter),
//       ),
//       Positioned(
//         top: 0,
//         left: 0,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   // topRight: Radius.circular(20),
//                   bottomRight: Radius.circular(15)),
//               color: context.isDarkMode ? Colors.white : Colors.black),
//           child: Text(
//             number.toString(),
//             style: TextStyle(
//                 color: context.isDarkMode ? Colors.black : Colors.white,
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//       Positioned(
//         bottom: 10,
//         right: 10,
//         left: 10,
//         child: Text(
//           episode.name ?? 'Episode $number',
//           maxLines: 2,
//           style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               overflow: TextOverflow.ellipsis),
//         ),
//       ),
//     ],
//   );
// }
