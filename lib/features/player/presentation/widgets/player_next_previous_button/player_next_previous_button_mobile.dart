part of 'player_next_previous_button.dart';

class _PlayerNextPreviousButtonMobile extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final bool enabled;

  const _PlayerNextPreviousButtonMobile._({
    super.key,
    required this.iconData,
    required this.onPressed,
    required this.enabled,
  });

  const _PlayerNextPreviousButtonMobile.next(
      {super.key, required this.onPressed, required this.enabled})
      : iconData = Icons.skip_next;

  const _PlayerNextPreviousButtonMobile.previous(
      {super.key, required this.onPressed, required this.enabled})
      : iconData = Icons.skip_previous;

  @override
  Widget build(BuildContext context) {
    final theme = PlayerTheme.of(context);

    return SizedBox.fromSize(
      size: theme.nextPreviousButtonSize,
      child: IconButton(
          style: theme.nextPreviousButtonStyle,
          onPressed: !enabled ? null : onPressed,

          icon: Icon(
            iconData,
          )),
    );
  }
}
