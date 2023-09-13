import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/usecases_container/watch_provider_repository_container.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_server_and_video_usecase.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/player/player.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server/state/bloc/load_video_server_and_video_container_bloc_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server_holder.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';
import 'package:meiyou/presentation/widgets/watch/state/movie_view/state/bloc/fetch_movie_bloc.dart';
import 'episode_view/state/episode_selector/episode_selector_bloc.dart';

final class SelectedServer {
  final String server;
  final VideoContainerEntity videoContainerEntity;
  final int selectedVideoIndex;

  const SelectedServer(
      {required this.server,
      required this.videoContainerEntity,
      required this.selectedVideoIndex});
}

typedef OnVideoServerSelected = void Function(SelectedServer selected);

typedef PlayerDependendicesInjector = Widget Function(Widget child);

class VideoServerListView extends StatefulWidget {
  final PlayerDependendicesInjector injector;
  final OnVideoServerSelected? onSelected;
  // fina/l String? url;
  const VideoServerListView(
      {super.key, this.onSelected, required this.injector});

  static Future _showSelectServerDialog(
      BuildContext context, Widget Function(Widget child) injector,
      [OnVideoServerSelected? onSelected]) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return injector(VideoServerListView(
            onSelected: onSelected,
            injector: injector,
          ));
        });
  }

  static Future showDialog(BuildContext context,
          [OnVideoServerSelected? onSelected]) =>
      _showSelectServerDialog(
          context,
          (child) => playerDependenciesInjector(context, child: child),
          onSelected);

  @override
  State<VideoServerListView> createState() => _VideoServerListViewState();
}

class _VideoServerListViewState extends State<VideoServerListView> {
  late final LoadVideoServerAndVideoContainerBloc bloc;

  @override
  void initState() {
    bloc = LoadVideoServerAndVideoContainerBloc(
        RepositoryProvider.of<WatchProviderRepositoryContainer>(context)
            .get<LoadServerAndVideoUseCase>(),
        RepositoryProvider.of<CacheRespository>(context))
      ..add(LoadVideoServerAndVideoContainer(
          BlocProvider.of<SourceDropDownBloc>(context).state.provider,
          BlocProvider.of<SelectedSearchResponseBloc>(context)
                      .state
                      .searchResponse
                      .type ==
                  MediaType.movie
              ? BlocProvider.of<FetchMovieBloc>(context).state.movie!.url
              : BlocProvider.of<EpisodeSelectorBloc>(context)
                  .state
                  .episodes[BlocProvider.of<CurrentEpisodeCubit>(context).state]
                  .url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      constraints: const BoxConstraints(minHeight: 100, maxHeight: 600),
      child: Column(
        children: [
          const Text(
            'Select Server',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          addVerticalSpace(10),
          BlocConsumer<LoadVideoServerAndVideoContainerBloc,
                  LoadVideoServerAndVideoContainerState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is LoadVideoServerAndVideoContainerLoading) {
                  return const CircularProgressIndicator();
                } else if (state.data != null) {
                  return Expanded(
                    child: ListView(
                      children: List.generate(
                          state.data!.length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: DefaultTextStyle(
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                        child: Text(
                                            state.data!.keys.elementAt(index))),
                                  ),
                                  addVerticalSpace(5),
                                  Column(
                                    children: List.generate(
                                        state.data!.values
                                            .elementAt(index)
                                            .videos
                                            .length,
                                        (i) => VideoServerHolder(
                                              onTap: (video) {
                                                if (widget.onSelected != null) {
                                                  widget.onSelected?.call(
                                                      SelectedServer(
                                                          server: state
                                                              .data!.keys
                                                              .elementAt(index),
                                                          videoContainerEntity:
                                                              state.data!.values
                                                                  .elementAt(
                                                                      index),
                                                          selectedVideoIndex:
                                                              state.data!.values
                                                                  .elementAt(
                                                                      index)
                                                                  .videos
                                                                  .indexOf(
                                                                      video)));
                                                } else {
                                                  print(video.url);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return widget.injector(
                                                        RepositoryProvider
                                                            .value(
                                                                value: VideoPlayerUseCaseContainer(
                                                                    VideoPlayerRepositoryImpl()),
                                                                child:
                                                                    BlocProvider(
                                                                  create: (context) =>
                                                                      SelectedServerCubit(
                                                                    SelectedServer(
                                                                      server: state
                                                                          .data!
                                                                          .keys
                                                                          .elementAt(
                                                                              index),
                                                                      videoContainerEntity: state
                                                                          .data!
                                                                          .values
                                                                          .elementAt(
                                                                              index),
                                                                      selectedVideoIndex: state
                                                                          .data!
                                                                          .values
                                                                          .elementAt(
                                                                              index)
                                                                          .videos
                                                                          .indexOf(
                                                                              video),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const MeiyouPlayer(),
                                                                )));
                                                  }));
                                                }
                                              },
                                              video: state.data!.values
                                                  .elementAt(index)
                                                  .videos[i],
                                            )),
                                  )
                                ],
                              )),
                    ),
                  );
                } else {
                  return defaultSizedBox;
                }
              },
              listener: (context, state) {
                if (state is LoadVideoServerAndVideoContainerFailed) {
                  showSnackBAr(context, text: state.error.toString());
                }
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}

// class _LazyLoadServer extends StatelessWidget {
//   final VideoSeverEntity videoSever;
//   final Set<MapEntry<VideoSeverEntity, VideoContainerEntity>> extracted;
//   final LoadVideoExtractorUseCase loadVideoExtractorUseCase;
//   final void Function(MapEntry<VideoSeverEntity, VideoContainerEntity> selected)
//       onTap;
//   final BaseProvider provider;
//   const _LazyLoadServer(
//       {super.key,
//       required this.onTap,
//       required this.videoSever,
//       required this.extracted,
//       required this.provider,
//       required this.loadVideoExtractorUseCase});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ExtractVideoBloc, ExtractVideoState>(
//         bloc: ExtractVideoBloc(loadVideoExtractorUseCase)
//           ..add(Extract(LoadVideoExtractorParams(
//               server: videoSever, provider: provider))),
//         builder: (context, state) {
//           if (state is ExtractVideoExtracting) {
//             return const CircularProgressIndicator();
//           }

//           if (state is ExtractVideoExtractionSuccess) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: DefaultTextStyle(
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700),
//                       child: Text(videoSever.name)),
//                 ),
//                 addVerticalSpace(5),
//                 Column(
//                   children: List.generate(
//                     state.videoContainer!.videos.length,
//                     (index) => VideoServerHolder(
//                       onTap: () => onTap.call(extracted.firstWhere((it) =>
//                           it.key == videoSever &&
//                           it.value == state.videoContainer)),
//                       video: state.videoContainer!.videos[index],
//                     ),
//                   ),
//                 )
//               ],
//             );
//           } else {
//             return defaultSizedBox;
//           }
//         },
//         listener: (context, state) {
//           if (state is ExtractVideoExtractionFailed) {
//             showSnackBAr(context, text: state.error.toString());
//           } else if (state is ExtractVideoExtractionSuccess) {
//             extracted.add(MapEntry(videoSever, state.videoContainer!));
//           }
//         });
//   }
// }
