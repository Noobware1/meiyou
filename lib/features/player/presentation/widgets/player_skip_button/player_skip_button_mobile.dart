part of 'player_skip_button.dart';

class _PlayerSkipButtonMobile extends StatelessWidget {
  final VoidCallback onPressed;
  final int seconds;
  const _PlayerSkipButtonMobile({
    super.key,
    required this.onPressed,
    required this.seconds,
  });
  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: Text('+$seconds s'));
  }
}
