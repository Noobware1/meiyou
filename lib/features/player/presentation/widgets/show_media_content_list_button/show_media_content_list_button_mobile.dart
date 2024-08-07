part of 'show_media_content_list_button.dart';

class _ShowMediaContentListButtonMobile extends StatelessWidget {
  final VoidCallback onPressed;
  const _ShowMediaContentListButtonMobile({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = PlayerTheme.of(context);
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        theme.showMediaContentListIcon,
        color: theme.iconColor,
      ),
    );
  }


}
