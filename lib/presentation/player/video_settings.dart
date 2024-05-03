import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';
import 'package:meiyou/presentation/core/resizeable_tab_bar.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class _VideoSettings extends ResizeableTabBar {
  const _VideoSettings({super.key})
      : super(
          children: const [
            SingleChildScrollView(child: _QualityTab()),
            SingleChildScrollView(child: _SubtitleTab()),
            SingleChildScrollView(child: _AudioTab())
          ],
          tabs: const [
            Tab(text: 'Quality'),
            Tab(text: 'Subtitles'),
            Tab(text: 'Audio')
          ],
        );

  static Widget buildTile(BuildContext context, String text, VoidCallback onTap,
      {required bool isSelected}) {
    return ListTile(
      title: Text(text,
          style: isSelected
              ? TextStyle(color: context.theme.colorScheme.primary)
              : null),
      onTap: onTap,
    );
  }
}

class _QualityTab extends StatefulWidget {
  const _QualityTab({super.key});

  @override
  State<_QualityTab> createState() => _QualityTabState();
}

class _QualityTabState extends State<_QualityTab> {
  @override
  Widget build(BuildContext context) {
    final videoTracks = InjectKtor.get<PlayerRepository>().videoTracks();
    final selected = InjectKtor.get<PlayerRepository>().selectedVideoTrack();
    return Column(
      children: videoTracks
          .mapList((track) => buildTile(track, isSelected: track == selected)),
    );
  }

  Widget buildTile(VideoTrack videoTrack, {required bool isSelected}) {
    return _VideoSettings.buildTile(
      context,
      videoTrack.toDisplayString(),
      () => onSelected(videoTrack),
      isSelected: isSelected,
    );
  }

  void onSelected(VideoTrack videoTrack) {
    InjectKtor.get<PlayerRepository>()
        .setVideoTrack(videoTrack)
        .then((value) => setState(() {}));
  }
}

extension on VideoTrack {
  String toDisplayString() => id == 'auto' ? 'Auto' : '$h x $w';
}

class _SubtitleTab extends StatefulWidget {
  const _SubtitleTab({super.key});

  @override
  State<_SubtitleTab> createState() => _SubtitleTabState();
}

class _SubtitleTabState extends State<_SubtitleTab> {
  @override
  Widget build(BuildContext context) {
    final subtitleTracks = InjectKtor.get<PlayerRepository>().subtitleTracks();
    final selected = InjectKtor.get<PlayerRepository>().selectedSubtitleTrack();
    return Column(
      children: subtitleTracks.mapList(
        (subtitle) => buildTile(subtitle, isSelected: subtitle == selected),
      ),
    );
  }

  Widget buildTile(SubtitleTrack subtitle, {required bool isSelected}) {
    return _VideoSettings.buildTile(
      context,
      subtitle.toDisplayString(),
      () {
        onSelected(subtitle);
      },
      isSelected: isSelected,
    );
  }

  void onSelected(SubtitleTrack subtitleTrack) {
    InjectKtor.get<PlayerRepository>()
        .setSubtitleTrack(subtitleTrack)
        .then((value) => setState(() {}));
  }
}

extension on SubtitleTrack {
  String toDisplayString() => id == 'no' ? 'None' : language ?? '#$id';
}

class _AudioTab extends StatefulWidget {
  const _AudioTab({super.key});

  @override
  State<_AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<_AudioTab> {
  @override
  Widget build(BuildContext context) {
    final audioTracks = InjectKtor.get<PlayerRepository>().audioTracks();
    final selected = InjectKtor.get<PlayerRepository>().selectedAudioTrack();

    return Column(
      children: audioTracks.mapList((audioTrack) =>
          buildTile(audioTrack, isSelected: audioTrack.id == selected.id)),
    );
  }

  Widget buildTile(AudioTrack audioTrack, {required bool isSelected}) {
    return _VideoSettings.buildTile(context, audioTrack.toDisplayString(), () {
      onSelected(audioTrack);
    }, isSelected: isSelected);
  }

  void onSelected(AudioTrack audioTrack) {
    InjectKtor.get<Player>()
        .setAudioTrack(audioTrack)
        .then((it) => setState(() {}));
  }
}

extension on AudioTrack {
  String toDisplayString() {
    if (id == 'no') return 'None';
    if (id == '1') return 'Default';
    return language ?? '#$id';
  }
}

class VideoSettingsButton extends StatelessWidget {
  const VideoSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!InjectKtor.playerCubit.isLoaded) return;
        InjectKtor.playerRepository.pause();
        ResizeableTabBar.show(
          context,
          const _VideoSettings(),
        );
      },
      icon: const Icon(Icons.video_settings_rounded),
    );
  }
}
