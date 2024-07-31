part of 'player_resize_button.dart';

class _PlayerResizeButtonMobile extends StatelessWidget {
  final StateNotifier<BoxFit> stateListenable;
  final VoidCallback onPressed;
  const _PlayerResizeButtonMobile({
    super.key,
    required this.stateListenable,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
        stateListenable: stateListenable,
        builder: (context, state, _) {
          return IconButton(
            icon: Icon(
              state != BoxFit.contain
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
            ),
            onPressed: onPressed,
          );
        });
  }
}
