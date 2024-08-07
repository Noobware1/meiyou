part of 'show_video_sources_button.dart';

class _ShowVideoSourcesButtonMobile extends StatelessWidget {
  final VoidCallback onPressed;
  const _ShowVideoSourcesButtonMobile({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final iconColor = PlayerTheme.of(context).iconColor;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.source_rounded,
        color: iconColor,
      ),
    );
  }
}
