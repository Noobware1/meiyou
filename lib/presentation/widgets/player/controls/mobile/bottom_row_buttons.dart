import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/play_back_speeds.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/domain/entities/link_and_source.dart';
import 'package:meiyou/presentation/blocs/player/resize_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou/presentation/blocs/player/video_track_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/apply_cancel.dart';
import 'package:meiyou/presentation/widgets/selector_dilaog_box.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';
import 'package:meiyou/core/utils/extenstions/tracks.dart';

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
                          ExtractedMediaCubit<Video>, ExtractedMediaState>(
                        bloc: context.bloc<ExtractedMediaCubit<Video>>(),
                        builder: (thirdContext, state) {
                          return Dialog(
                            child: ArrowSelectorDialogBox(
                                defaultValue: AppUtils.trySync(() => context
                                        .bloc<SelectedVideoDataCubit>()
                                        .state
                                        .getLinkAndSource(context)) ??
                                    LinkAndSourceEntity(
                                      link: ExtractorLink(name: '', url: ''),
                                      source: VideoSource(),
                                    ),
                                label: 'Change Source',
                                builder: (context, index, data) {
                                  return data.toString();
                                },
                                data: trySync(() => context
                                        .repository<
                                            VideoPlayerRepositoryUseCases>()
                                        .convertExtractedVideoDataListUseCase(
                                            state.data)) ??
                                    [],
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
            onTap: () {
              showDialog(
                  context: context,
                  builder: (c) {
                    return Dialog(
                        child: RepositoryProvider.value(
                      value: playerProvider(context),
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.bloc<SubtitleCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.bloc<ExtractedMediaCubit<Video>>(),
                          ),
                          BlocProvider.value(
                            value: context.bloc<SelectedVideoDataCubit>(),
                          ),
                        ],
                        child: const AudioAndSubtitlesWidget(),
                      ),
                    ));
                  });
            },
            text: 'Audio & Subtitles',
            icon: Icons.subtitles_outlined),
      ],
    );
  }
}

class AudioAndSubtitlesWidget extends StatefulWidget {
  const AudioAndSubtitlesWidget({super.key});

  @override
  State<AudioAndSubtitlesWidget> createState() =>
      _AudioAndSubtitlesWidgetState();
}

class _AudioAndSubtitlesWidgetState extends State<AudioAndSubtitlesWidget> {
  late AudioTrack audioTrack = playerProvider(context).player.state.track.audio;
  late Subtitle subtitle = context.bloc<SubtitleCubit>().state.current;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 600, maxHeight: 300, minHeight: 20)
          : const BoxConstraints(maxWidth: 700, maxHeight: 350, minHeight: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: ArrowSelectorListView(
                  label: 'Audio',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  defaultValue: audioTrack,
                  builder: (context, index, audioTrack) {
                    return audioTrack == AudioTrack.auto()
                        ? 'Auto'
                        : '#${audioTrack.id}';
                  },
                  data: playerProvider(context)
                      .player
                      .state
                      .tracks
                      .getFixedAudioTracks,
                  onSelected: (track) {
                    setState(() {
                      audioTrack = track;
                    });
                  },
                ),
              ),
              const VerticalDivider(
                thickness: 1,
              ),
              ArrowSelectorListView(
                label: 'Subtitles',
                crossAxisAlignment: CrossAxisAlignment.start,
                defaultValue: subtitle,
                builder: (context, index, subtitle) {
                  return subtitle.language ?? 'Auto';
                },
                data: context.bloc<SubtitleCubit>().state.subtitles,
                onSelected: (track) {
                  setState(() {
                    subtitle = track;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AppyCancel(
                      onApply: () {
                        if (audioTrack !=
                            playerProvider(context).player.state.track.audio) {
                          playerProvider(context)
                              .player
                              .setAudioTrack(audioTrack);
                        }

                        if (subtitle !=
                            context.bloc<SubtitleCubit>().state.current) {
                          context
                              .bloc<SubtitleCubit>()
                              .changeSubtitle(subtitle);
                        }
                        context.pop();
                      },
                      onCancel: () {
                        context.pop();
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
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
