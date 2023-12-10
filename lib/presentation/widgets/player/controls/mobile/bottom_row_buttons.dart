import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/play_back_speeds.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_source.dart';
import 'package:meiyou/presentation/blocs/player/resize_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/video_track_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/selector_dilaog_box.dart';
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

class VideoPlayerBottomRowButtonsMobile extends StatelessWidget {
  const VideoPlayerBottomRowButtonsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconButton(
            onTap: () {
              context.bloc<ResizeCubit>().resize(context);
            },
            text: 'Resize',
            icon: Icons.aspect_ratio_rounded),
        _IconButton(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (secondContext) => RepositoryProvider.value(
                        value: playerProvider(context),
                        child: Dialog(
                          child: ArrowSelectorDialogBox(
                              defaultValue:
                                  playerProvider(context).player.state.rate,
                              label: 'Change Playback speed',
                              builder: (context, index, speed) {
                                return speed == 1.0 ? 'Normal' : '${speed}x';
                              },
                              data: playbackSpeeds,
                              onApply: (val) {
                                playerProvider(context).player.setRate(val);
                                context.pop();
                              },
                              onCancel: () {
                                context.pop();
                              }),
                        ),
                      ));
            },
            text: 'Speed',
            icon: Icons.speed),
        _IconButton(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (secondContext) => BlocBuilder<
                          ExtractedVideoDataCubit, ExtractedVideoDataState>(
                        bloc: context.bloc<ExtractedVideoDataCubit>(),
                        builder: (thirdContext, state) {
                          return Dialog(
                            child: ArrowSelectorDialogBox(
                                defaultValue: context
                                    .bloc<SelectedVideoDataCubit>()
                                    .state
                                    .getLinkAndSource(context),
                                label: 'Change Source',
                                builder: (context, index, data) {
                                  return data.toString();
                                },
                                data: context
                                    .repository<VideoPlayerRepositoryUseCases>()
                                    .convertExtractedVideoDataListUseCase(
                                        state.data),
                                onApply: (data) {
                                  context
                                      .bloc<SelectedVideoDataCubit>()
                                      .setStateFromData(context, state, data);

                                  secondContext.pop();
                                },
                                onCancel: () {
                                  secondContext.pop();
                                }),
                          );
                        },
                      ));
            },
            text: 'Source',
            icon: Icons.playlist_play_rounded),
        _IconButton(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (c) {
                    return StreamBuilder<List<VideoTrack>>(
                        initialData: playerProvider(context)
                            .player
                            .state
                            .tracks
                            .video
                            .where((e) => e.id != 'no')
                            .toList(),
                        stream: playerProvider(context)
                            .player
                            .stream
                            .tracks
                            .asyncMap(
                              (data) => data.video
                                  .where((e) => e.id != 'no')
                                  .toList(),
                            ),
                        builder: (c, snapshot) {
                          return Dialog(
                            child: ArrowSelectorDialogBox(
                              defaultValue:
                                  context.bloc<VideoTrackCubit>().state,
                              label: 'Change Quality',
                              builder: (context, index, track) {
                                return track.id == 'auto'
                                    ? 'Auto'
                                    : '${track.h ?? 0}p';
                              },
                              data: snapshot.data ?? [],
                              onApply: (track) {
                                context
                                    .bloc<VideoTrackCubit>()
                                    .changeVideoTrack(context, track);
                                c.pop();
                              },
                              onCancel: () {
                                c.pop();
                              },
                            ),
                          );
                        });
                  });
            },
            text: 'Qualites',
            icon: Icons.hd_outlined),
        _IconButton(
            onTap: () {},
            text: 'Audio & Subtitles',
            icon: Icons.subtitles_outlined),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _IconButton(
      {required this.icon, required this.text, required this.onTap});

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
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              addHorizontalSpace(10),
              DefaultTextStyle(
                style: const TextStyle(fontSize: 12, color: Colors.white),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
