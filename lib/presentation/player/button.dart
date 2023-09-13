import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_server_usecase.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/player/change_subtitle.dart';
import 'package:meiyou/presentation/player/initialise_player.dart';
import 'package:meiyou/presentation/player/video_controls/change_quality.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/player_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/resize_mode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/episode_selector.dart';
import 'package:meiyou/presentation/widgets/season_selector/season_selector.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/watch_view.dart';

class VideoPlayerButtons extends StatefulWidget {
  const VideoPlayerButtons({super.key});

  @override
  State<VideoPlayerButtons> createState() => _VideoPlayerButtonsState();
}

class _VideoPlayerButtonsState extends State<VideoPlayerButtons> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        // height: 50,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Expanded(
            //   child:
            _BuildIconButton(
              icon: Icons.aspect_ratio_rounded,
              text: 'Resize',
              onTap: () {
                BlocProvider.of<ResizeModeCubit>(context).resize();
                showSnackBAr(context,
                    text: BlocProvider.of<ResizeModeCubit>(context).state.name);
              },
              // ),
            ),
            // Expanded(
            //   child:
            _BuildIconButton(
              icon: Icons.hd_rounded,
              text: 'Quailties',
              onTap: () {
                ChangeQuality.showQuailtiesDialog(context, player(context));
              },
              // ),
            ),
            // Expanded(
            //   child:
            _BuildIconButton(
              icon: Icons.source_rounded,
              text: 'Subtitles',
              onTap: () {
                ChangeSubtitle.showSubtitlesDialog(context, player(context));
              },
            ),
            // ),
            // Expanded(
            //   child:
            _BuildIconButton(
                icon: Icons.playlist_play_rounded,
                text: 'Servers',
                onTap: () {
                  final pos = player(context).state.position;
                  VideoServerListView.showDialog(context, (value) {
                    if (value.selectedVideoIndex !=
                        BlocProvider.of<SelectedServerCubit>(context)
                            .state
                            .selectedVideoIndex) {
                      BlocProvider.of<SelectedServerCubit>(context)
                          .changeServer(value);

                      initialise(context, player(context),
                          RepositoryProvider.of<VideoController>(context), pos);
                      // Navigator.pop(context);
                    }
                  });
                }),

            // ),
            if (BlocProvider.of<SelectedSearchResponseBloc>(context)
                    .state
                    .searchResponse
                    .type !=
                MediaType.movie)
              _BuildIconButton(
                icon: Icons.video_library_sharp,
                text: 'Episodes',
                onTap: () {
                  final injected = playerDependenciesInjector(context,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addVerticalSpace(10),
                            const SeasonSelector(),
                            addVerticalSpace(10),
                            const EpisodeSelector(),
                            addVerticalSpace(10),
                            Expanded(
                                child: SingleChildScrollView(child: WatchView(
                              onServerSelected: (server) {
                                if (server.videoContainerEntity !=
                                    BlocProvider.of<SelectedServerCubit>(
                                            context)
                                        .state
                                        .videoContainerEntity) {
                                  BlocProvider.of<SelectedServerCubit>(context)
                                      .changeServer(server);

                                  initialise(
                                      context,
                                      player(context),
                                      RepositoryProvider.of<VideoController>(
                                          context));
                                }
                              },
                            ))),
                          ]));
                  showModalBottomSheet(
                      backgroundColor: Colors.black,
                      context: context,
                      builder: (context) => injected);
                },
              ),
            // ),
          ].map((e) => Expanded(child: e)).toList(),
        ),
      ),
    );
  }
}

class _BuildIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _BuildIconButton(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              Expanded(
                flex: 4,
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  child: Text(
                    text,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
