part of 'video_settings_button.dart';

class _VideoSettingsButtonMobile extends StatelessWidget {
  final VoidCallback onPressed;
  const _VideoSettingsButtonMobile({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.video_settings_rounded,
        color: PlayerTheme.of(context).iconColor,
      ),
    );
  }
}
