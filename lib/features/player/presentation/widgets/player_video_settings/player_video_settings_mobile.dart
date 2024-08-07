part of 'player_video_settings.dart';

class _PlayerVideoSettingsMobile extends ResizableTabBar {
  final List<VideoTrack> videoTracks;
  final VideoTrack selectedVideoTrack;
  final List<SubtitleTrack> subtitleTracks;
  final SubtitleTrack selectedSubtitleTrack;
  final List<AudioTrack> audioTracks;
  final AudioTrack selectedAudioTrack;
  final Future<void> Function(VideoTrack) onVideoTrackSelected;
  final Future<void> Function(SubtitleTrack) onSubtitleTrackSelected;
  final Future<void> Function(AudioTrack) onAudioTrackSelected;
  _PlayerVideoSettingsMobile({
    required this.videoTracks,
    required this.selectedVideoTrack,
    required this.subtitleTracks,
    required this.selectedSubtitleTrack,
    required this.audioTracks,
    required this.selectedAudioTrack,
    required this.onVideoTrackSelected,
    required this.onSubtitleTrackSelected,
    required this.onAudioTrackSelected,
  }) : super(tabs: const [
          Tab(text: 'Quality'),
          Tab(text: 'Subtitles'),
          Tab(text: 'Audio')
        ], children: [
          SingleChildScrollView(
              child: _QualityTab(
                  tracks: videoTracks,
                  selected: selectedVideoTrack,
                  onSelected: onVideoTrackSelected)),
          SingleChildScrollView(
              child: _SubtitleTab(
                  tracks: subtitleTracks,
                  selected: selectedSubtitleTrack,
                  onSelected: onSubtitleTrackSelected)),
          SingleChildScrollView(
              child: _AudioTab(
                  tracks: audioTracks,
                  selected: selectedAudioTrack,
                  onSelected: onAudioTrackSelected)),
        ]);
}

class _QualityTab extends _VideoSettingsTab<VideoTrack> {
  const _QualityTab({
    super.key,
    required super.tracks,
    required super.selected,
    required super.onSelected,
  });

  @override
  bool equals(VideoTrack a, VideoTrack b) {
    return a.id == b.id;
  }

  @override
  String toDisplayString(VideoTrack track) {
    return track.toDisplayString();
  }
}

abstract class _VideoSettingsTab<T> extends StatefulWidget {
  final List<T> tracks;
  final T selected;
  final Future<void> Function(T) onSelected;
  const _VideoSettingsTab({
    super.key,
    required this.tracks,
    required this.selected,
    required this.onSelected,
  });

  bool equals(T a, T b);

  String toDisplayString(T track);

  @override
  State<_VideoSettingsTab<T>> createState() => __VideoStateSettingsTab<T>();
}

class __VideoStateSettingsTab<T> extends State<_VideoSettingsTab<T>> {
  late T selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final theme = PlayerTheme.of(context);
    final (normalStyle, selectedStyle) = theme.let(
        (it) => (it.videoSettingsTextStyle, it.videoSettingsSelectedTextStyle));

    final padding = theme.videoSettingsPadding;

    return Column(
      children: widget.tracks.mapList((track) {
        final isSelected = widget.equals(track, selected);

        return buildTile(
          track,
          isSelected: isSelected,
          style: isSelected ? selectedStyle : normalStyle,
          padding: padding,
        );
      }),
    );
  }

  Widget buildTile(T track,
      {required bool isSelected,
      required TextStyle style,
      required EdgeInsets padding}) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          widget.onSelected(track);
          setState(() {
            selected = track;
          });
        }
      },
      child: Container(
        padding: padding,
        alignment: Alignment.centerLeft,
        child: Text(
          widget.toDisplayString(track),
          style: style,
        ),
      ),
    );
  }
}

extension on VideoTrack {
  String toDisplayString() => id == 'auto' ? 'Auto' : '$w x $h';
}

class _SubtitleTab extends _VideoSettingsTab<SubtitleTrack> {
  const _SubtitleTab({
    super.key,
    required super.tracks,
    required super.selected,
    required super.onSelected,
  });

  @override
  bool equals(SubtitleTrack a, SubtitleTrack b) {
    return a.id == b.id;
  }

  @override
  String toDisplayString(SubtitleTrack track) {
    return track.toDisplayString();
  }
}

extension on SubtitleTrack {
  String toDisplayString() => id == 'no' ? 'None' : language ?? '#$id';
}

class _AudioTab extends _VideoSettingsTab<AudioTrack> {
  const _AudioTab({
    super.key,
    required super.tracks,
    required super.selected,
    required super.onSelected,
  });

  @override
  bool equals(AudioTrack a, AudioTrack b) {
    return a.id == b.id;
  }

  @override
  String toDisplayString(AudioTrack track) {
    return track.toDisplayString();
  }
}

extension on AudioTrack {
  String toDisplayString() {
    if (id == 'no') return 'None';
    if (id == '1') return 'Default';
    return language ?? '#$id';
  }
}
