part of 'player_title.dart';

class _PlayerTitleMobile extends StatelessWidget {
  final Media media;
  final MediaContent content;
  const _PlayerTitleMobile(
      {super.key, required this.media, required this.content});

  static const _movieFormats = [
    MediaFormat.movie,
    MediaFormat.animeMovie,
    MediaFormat.documentary,
    MediaFormat.others
  ];

  @override
  Widget build(BuildContext context) {
    final String title = media.title.trimLeft();
    final String? subtitle = _movieFormats.contains(media.format)
        ? null
        : (content.name ?? MediaContentHelper.getDefaultName(content, media));

    final theme = PlayerTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.titleTextStyle,
          textAlign: TextAlign.left,
        ),
        if (subtitle != null)
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: theme.subtitleTextStyle,
          ),
      ],
    );
  }
}
