import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/fullscreen.dart';
// import 'package:meiyou/presentation/player/video_controls/get_player.dart';
import 'package:meiyou/core/utils/player_utils.dart';

class AddKeyBoardShortcuts extends StatelessWidget {
  final Widget child;
  final AnimationController forwardAnimationController;
  final AnimationController rewindAnimationController;
  const AddKeyBoardShortcuts(
      {Key? key,
      required this.child,
      required this.forwardAnimationController,
      required this.rewindAnimationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(bindings: {
      // Default key-board shortcuts.
      // https://support.google.com/youtube/answer/7631406
      const SingleActivator(LogicalKeyboardKey.mediaPlay): () =>
          player(context).play(),
      const SingleActivator(LogicalKeyboardKey.mediaPause): () =>
          player(context).pause(),
      const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () =>
          player(context).playOrPause(),
      const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () =>
          player(context).next(),
      const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious): () =>
          player(context).previous(),
      const SingleActivator(LogicalKeyboardKey.space): () =>
          player(context).playOrPause(),
      const SingleActivator(LogicalKeyboardKey.keyJ): () {
        final rate =
            player(context).state.position - const Duration(seconds: 10);
        player(context).seek(rate);
      },
      const SingleActivator(LogicalKeyboardKey.keyI): () {
        final rate =
            player(context).state.position + const Duration(seconds: 10);

        player(context).seek(rate);
      },
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
        final rate =
            player(context).state.position - const Duration(seconds: 10);
        startAnimation(rewindAnimationController);
        player(context).seek(rate);
      },
      const SingleActivator(LogicalKeyboardKey.arrowRight): () {
        final rate =
            player(context).state.position + const Duration(seconds: 10);
        startAnimation(forwardAnimationController);

        player(context).seek(rate);
      },
      const SingleActivator(LogicalKeyboardKey.arrowUp): () {
        final volume = player(context).state.volume + 5.0;
        player(context).setVolume(volume.clamp(0.0, 100.0));
      },
      const SingleActivator(LogicalKeyboardKey.arrowDown): () {
        final volume = player(context).state.volume - 5.0;
        player(context).setVolume(volume.clamp(0.0, 100.0));
      },
      const SingleActivator(LogicalKeyboardKey.keyF): () =>
          toggleFullscreen(context),
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          exitFullscreen(context),
    }, child: child);
  }
}
