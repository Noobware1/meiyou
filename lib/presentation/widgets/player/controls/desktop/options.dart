
import 'package:flutter/material.dart'
    hide
        PopupMenuButton,
        PopupMenuButtonState,
        PopupMenuEntry,
        PopupMenuItemState,
        PopupMenuItemBuilder,
        PopupMenuItemSelected,
        PopupMenuDivider,
        PopupMenuItem;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/play_back_speeds.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/tracks.dart';
import 'package:meiyou/presentation/blocs/player/playback_speed.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou/presentation/blocs/player/video_track_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/custom_popup_button.dart';
import 'package:meiyou_extenstions/extenstions.dart';

// BUTTON: OPTIONS BUTTON

/// MaterialDesktop design options button.
class MaterialDesktopOptionsButton extends StatelessWidget {
  /// Icon for [MaterialDesktopOptionsButton].
  final Widget? icon;

  /// Overriden icon size for [MaterialDesktopOptionsButton].
  final double? iconSize;

  /// Overriden icon color for [MaterialDesktopOptionsButton].
  final Color? iconColor;

  const MaterialDesktopOptionsButton({
    super.key,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
          popupMenuTheme: PopupMenuThemeData(
              color: context.theme.colorScheme.onSurface.withOpacity(0.2))),
      child: CustomPopupMenuButton(
          position: PopupMenuPosition.over,
          tooltip: 'show options',
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: MultiRepositoryProvider(
                providers: [
                  RepositoryProvider.value(
                    value: playerProvider(context),
                  ),
                  RepositoryProvider.value(
                    value: context.repository<VideoPlayerRepositoryUseCases>(),
                  ),
                ],
                child: MultiBlocProvider(providers: [
                  BlocProvider.value(value: context.bloc<PlaybackSpeedCubit>()),
                  BlocProvider.value(value: context.bloc<VideoTrackCubit>()),
                  BlocProvider.value(
                      value: context.bloc<ExtractedVideoDataCubit>()),
                  BlocProvider.value(value: context.bloc<SubtitleCubit>()),
                  BlocProvider.value(
                      value: context.bloc<SelectedVideoDataCubit>())
                ], child: const OptionsMenu()),
              ))
            ];
          },
          icon: const Icon(Icons.settings_outlined),
          iconSize: iconSize),
    );
  }
}

class OptionsMenu extends StatefulWidget {
  const OptionsMenu({super.key});

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  int _value = 0;
  bool change = false;

  late List<Widget> children = [
    BlocBuilder<SelectedVideoDataCubit, SelectedVideoDataState>(
        builder: (context, selected) {
      return BlocBuilder<ExtractedVideoDataCubit, ExtractedVideoDataState>(
        builder: (context, state) {
          return _PopUpItemListBody(
              defaultValue: selected.getLinkAndSource(context),
              label: 'Sources',
              builder: (context, index, data) => Text(data.toString()),
              data: context
                  .repository<VideoPlayerRepositoryUseCases>()
                  .convertExtractedVideoDataListUseCase(state.data),
              onSelected: (data) {
                context
                    .bloc<SelectedVideoDataCubit>()
                    .setStateFromData(context, state, data);

                setChangeFalse();
              },
              onExit: () {
                setChangeFalse();
              });
        },
      );
    }),
    StreamBuilder<List<VideoTrack>>(
        initialData:
            playerProvider(context).player.state.tracks.getFixedVideoTracks,
        stream: playerProvider(context)
            .player
            .stream
            .tracks
            .asyncMap((e) => e.getFixedVideoTracks),
        builder: (context, snapshot) {
          return BlocBuilder<VideoTrackCubit, VideoTrack>(
              builder: (context, track) {
            return _PopUpItemListBody(
                defaultValue: track,
                label: 'Qualities',
                builder: (context, index, track) {
                  return Text(
                      track == VideoTrack.auto() ? 'Auto' : '${track.h ?? 0}p');
                },
                data: snapshot.data ?? [],
                onSelected: (track) {
                  context
                      .bloc<VideoTrackCubit>()
                      .changeVideoTrack(context, track);
                  setChangeFalse();
                },
                onExit: () {
                  setChangeFalse();
                });
          });
        }),
    BlocBuilder<PlaybackSpeedCubit, double>(builder: (context, speed) {
      return _PopUpItemListBody(
          defaultValue: speed,
          label: 'Playback speed',
          builder: (context, index, speed) {
            return Text(speed == 1.0 ? 'Normal' : speed.toString());
          },
          data: playbackSpeeds,
          onSelected: (speed) {
            context.bloc<PlaybackSpeedCubit>().setPlaybackSpeed(context, speed);
            setChangeFalse();
          },
          onExit: () {
            setChangeFalse();
          });
    }),
    BlocBuilder<SubtitleCubit, SubtitleState>(builder: (context, state) {
      return _PopUpItemListBody(
          defaultValue: state.current,
          label: 'Subtitles',
          builder: (context, index, subtitle) {
            return Text(subtitle.langauge ?? 'Auto');
          },
          data: state.subtitles,
          onSelected: (subtitle) {
            context.bloc<SubtitleCubit>().changeSubtitle(subtitle);
            setChangeFalse();
          },
          onExit: () {
            setChangeFalse();
          });
    }),
    StreamBuilder<List<AudioTrack>>(
        initialData:
            playerProvider(context).player.state.tracks.getFixedAudioTracks,
        stream: playerProvider(context)
            .player
            .stream
            .tracks
            .asyncMap((e) => e.getFixedAudioTracks),
        builder: (context, listSnapshot) {
          return StreamBuilder<AudioTrack>(
              initialData: playerProvider(context).player.state.track.audio ==
                      AudioTrack.no()
                  ? AudioTrack.auto()
                  : playerProvider(context).player.state.track.audio,
              stream: playerProvider(context).player.stream.track.asyncMap(
                  (e) =>
                      e.audio == AudioTrack.no() ? AudioTrack.auto() : e.audio),
              builder: (context, snapshot) {
                return _PopUpItemListBody(
                    defaultValue: snapshot.data!,
                    label: 'Subtitles',
                    builder: (context, index, audio) {
                      return Text(audio.id == 'auto'
                          ? audio.id.toUpperCaseFirst()
                          : '#${audio.id}');
                    },
                    data: listSnapshot.data ?? [AudioTrack.no()],
                    onSelected: (audio) {
                      playerProvider(context).player.setAudioTrack(audio);
                      setChangeFalse();
                    },
                    onExit: () {
                      setChangeFalse();
                    });
              });
        }),
  ];

  void setChangeTrue() {
    setState(() {
      change = true;
    });
  }

  void setChangeFalse() {
    setState(() {
      change = false;
    });
  }

  Widget _mainWidget() {
    return Column(
      children: [
        addVerticalSpace(10),
        BlocBuilder<SelectedVideoDataCubit, SelectedVideoDataState>(
            builder: (context, selected) {
          return BlocBuilder<ExtractedVideoDataCubit, ExtractedVideoDataState>(
            builder: (context, state) {
              return _builditem(
                  value: 0,
                  label: 'Sources',
                  icon: Icons.speed_outlined,
                  text: selected is SelectedVideoDataStateInital
                      ? ''
                      : '(${state.data[selected.serverIndex].link.name})');
            },
          );
        }),
        addVerticalSpace(10),
        BlocBuilder<VideoTrackCubit, VideoTrack>(builder: (context, track) {
          return _builditem(
              value: 1,
              label: 'Qualities',
              icon: Icons.hd_outlined,
              text: track == VideoTrack.auto() ? 'Auto' : '${track.h ?? 0}p');
        }),
        addVerticalSpace(10),
        BlocBuilder<PlaybackSpeedCubit, double>(builder: (context, speed) {
          return _builditem(
              value: 2,
              label: 'Playback speed',
              icon: Icons.speed_outlined,
              text: speed == 1.0 ? 'Normal' : '${speed}x');
        }),
        addVerticalSpace(10),
        BlocBuilder<SubtitleCubit, SubtitleState>(builder: (context, state) {
          return _builditem(
              value: 3,
              label: 'Subtitle',
              icon: Icons.closed_caption_outlined,
              text: state.current.langauge ?? 'Auto');
        }),
        addVerticalSpace(10),
        StreamBuilder<AudioTrack>(
            stream: playerProvider(context).player.stream.track.asyncMap((e) =>
                e.audio == AudioTrack.no() ? AudioTrack.auto() : e.audio),
            initialData: playerProvider(context).player.state.track.audio,
            builder: (context, snapshot) {
              return _builditem(
                  value: 4,
                  label: 'Audio',
                  icon: Icons.audiotrack_rounded,
                  text: snapshot.data == AudioTrack.auto()
                      ? 'Auto'
                      : '#${snapshot.data!.id}');
            }),
        addVerticalSpace(10),
      ],
    );
  }

  _builditem(
      {required int value,
      required String label,
      required IconData icon,
      required String text}) {
    return Material(
      animationDuration: animationDuration,
      type: MaterialType.button,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _value = value;
            change = true;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, size: 25),
                  addHorizontalSpace(10),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
            addHorizontalSpace(50),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            addHorizontalSpace(8),
            const Icon(Icons.arrow_forward_ios, size: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      child: change ? children[_value] : _mainWidget(),
    );
  }
}

class _PopUpItemListBody<T> extends StatefulWidget {
  final T defaultValue;
  final void Function() onExit;

  // final void Function(Offset offset) changeOffsetCallback;
  final Widget Function(BuildContext context, int index, T element) builder;
  final List<T> data;
  final String label;
  final void Function(T value) onSelected;
  const _PopUpItemListBody({
    super.key,
    required this.defaultValue,
    required this.label,
    required this.builder,
    required this.data,
    required this.onSelected,
    required this.onExit,
    // required this.changeOffsetCallback,
  });

  @override
  State<_PopUpItemListBody<T>> createState() => __PopUpItemListBodyState<T>();
}

class __PopUpItemListBodyState<T> extends State<_PopUpItemListBody<T>> {
  late final ScrollController _controller;
  late T selected;

  @override
  void initState() {
    _controller = ScrollController();
    selected = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(player(context).state.track.video);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 350, minWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: widget.onExit,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    )),
                addHorizontalSpace(10),
                Text(
                  widget.label,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: ScrollbarTheme(
              data: const ScrollbarThemeData(
                  thickness: MaterialStatePropertyAll(5.0),
                  thumbColor: MaterialStatePropertyAll(Colors.grey)),
              child: Scrollbar(
                // thumbVisibility: true,
                controller: _controller,
                child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
                    children: List.generate(
                        widget.data.length,
                        (index) => _ArrowButton(
                            isSelected: selected == widget.data[index],
                            child: widget.builder(
                                context, index, widget.data[index]),
                            onTap: () {
                              setState(() {
                                selected = widget.data[index];
                                widget.onSelected(selected);
                              });
                            }))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  final Widget child;
  const _ArrowButton({
    required this.isSelected,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: const Duration(milliseconds: 200),
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
            // stream: null,
            builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  visible: isSelected,
                  replacement: const SizedBox(
                    height: 25,
                    width: 25,
                  ),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      Icons.done,
                      size: 25,
                    ),
                  ),
                ),
                addHorizontalSpace(10),
                Flexible(child: child)
              ],
            ),
          );
        }),
      ),
    );
  }
}
