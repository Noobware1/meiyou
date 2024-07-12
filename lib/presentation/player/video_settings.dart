import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';
import 'package:meiyou/presentation/common/notifers/link_and_data_notifer.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/core/resizeable_tab_bar.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class _VideoSettings extends ResizeableTabBar {
  const _VideoSettings({super.key})
      : super(
          children: const [
            // SingleChildScrollView(child: _ServerTab()),
            SingleChildScrollView(child: _QualityTab()),
            SingleChildScrollView(child: _SubtitleTab()),
            SingleChildScrollView(child: _AudioTab())
          ],
          tabs: const [
            // Tab(text: 'Server'),
            Tab(text: 'Quality'),
            Tab(text: 'Subtitles'),
            Tab(text: 'Audio')
          ],
        );

  static Widget buildTile(BuildContext context, String text, VoidCallback onTap,
      {required bool isSelected}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: isSelected
              ? TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontStyle: isSelected ? FontStyle.italic : FontStyle.normal,
                  fontSize: MobileFontSize.normal,
                )
              : null,
        ),
      ),
    );
  }
}

extension on Quality {
  bool get isAuto => height == 0 && width == 0;
}

// class _ServerTab extends StatelessWidget {
//   const _ServerTab({super.key});

//   String toDisplayString(ContentDataLink link, VideoSource source) {
//     return buildString((it) {
//       it.write(link.name);
//       if (source.format == VideoFormat.hls) {
//         it.write(' - Multi');
//       } else if (source.quality != null && !(source.quality?.isAuto ?? true)) {
//         it.write(' - ${source.quality!.height}p');
//       }

//       if (source.isBackup) {
//         it.write(' (Backup)');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetItListenableBuilder<LinkAndVideoNotifer, LinkAndVideoState>(
//         builder: (context, state) {
//       return state.when(
//           data: (selected, data) {
//             final selectedSource = state.source;
//             final children = data
//                 .map((pair) => pair.second.sources.map((source) {
//                       final isSelected = source == selectedSource;
//                       return buildTile(context, pair.first, source,
//                           isSelected: isSelected);
//                     }))
//                 .flattened
//                 .toList();

//             return Column(
//               children: children,
//             );
//           },
//           initial: () => const Dialog(
//                 child: Center(child: CircularProgressIndicator()),
//               ));
//     });
//   }

//   Widget buildTile(
//       BuildContext context, ContentDataLink link, VideoSource source,
//       {required bool isSelected}) {
//     return _VideoSettings.buildTile(
//       context,
//       toDisplayString(link, source),
//       () => onSelected(source),
//       isSelected: isSelected,
//     );
//   }

//   void onSelected(VideoSource source) {
//     getIt.playerRepository.setVideoSource(source);
//   }
// }

class _QualityTab extends StatefulWidget {
  const _QualityTab({super.key});

  @override
  State<_QualityTab> createState() => _QualityTabState();
}

class _QualityTabState extends State<_QualityTab> {
  @override
  Widget build(BuildContext context) {
    final videoTracks = getIt.get<PlayerRepository>().videoTracks();
    final selected = getIt.get<PlayerRepository>().selectedVideoTrack();
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
    getIt
        .get<PlayerRepository>()
        .setVideoTrack(videoTrack)
        .then((value) => setState(() {}));
  }
}

extension on VideoTrack {
  String toDisplayString() => id == 'auto' ? 'Auto' : '$w x $h';
}

class _SubtitleTab extends StatefulWidget {
  const _SubtitleTab({super.key});

  @override
  State<_SubtitleTab> createState() => _SubtitleTabState();
}

class _SubtitleTabState extends State<_SubtitleTab> {
  @override
  Widget build(BuildContext context) {
    final subtitleTracks = getIt.get<PlayerRepository>().subtitleTracks();
    final selected = getIt.get<PlayerRepository>().selectedSubtitleTrack();
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
    getIt
        .get<PlayerRepository>()
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
    final audioTracks = getIt.get<PlayerRepository>().audioTracks();
    final selected = getIt.get<PlayerRepository>().selectedAudioTrack();

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
    getIt.get<Player>().setAudioTrack(audioTrack).then((it) => setState(() {}));
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
        if (!getIt.playerNotifer.isLoaded) return;
        getIt.playerRepository.pause();
        ResizeableTabBar.show(
          context,
          const _VideoSettings(),
        );
      },
      icon: const Icon(
        Icons.video_settings_rounded,
        color: Colors.white,
      ),
    );
  }
}
