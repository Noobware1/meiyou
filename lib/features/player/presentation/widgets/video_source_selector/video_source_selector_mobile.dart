part of 'video_source_selector.dart';

class _VideoSourceSelector extends StatelessWidget {
  final VideoSource selectedSource;
  final Map<MediaLink, List<VideoSource>> linkAndSources;
  final void Function(VideoSource) onSourceSelected;
  const _VideoSourceSelector({
    super.key,
    required this.selectedSource,
    required this.linkAndSources,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> names = [];
    final List<VideoSource> sources = [];

    for (var link in linkAndSources.keys) {
      for (var source in linkAndSources[link]!) {
        final name = buildString((it) {
          it.write(link.name);
          if (source.format == VideoFormat.hls) {
            it.write(' - Multi');
          } else if (source.quality != null && source.quality != Quality.auto) {
            it.write(' - ${source.quality!.height}p');
          }

          if (source.isBackup) {
            it.write(' (Backup)');
          }
        });
        names.add(name);
        sources.add(source);
      }
    }

    return ListDailog<VideoSource>(
      title: 'Change video source',
      keys: names,
      values: sources,
      onSelected: onSourceSelected,
      selected: selectedSource,
    );
  }
}
