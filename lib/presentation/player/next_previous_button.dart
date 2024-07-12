import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

// import 'package:media_kit/media_kit.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/player/notifers/player_state_notifer.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class _Button extends StatelessWidget {
  const _Button({
    super.key,
  });

  static const buttonSize = Size(75.0, 75.0);
  static const ButtonStyle style = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(buttonSize),
    iconSize: MaterialStatePropertyAll(55.0),
    shape: MaterialStatePropertyAll(CircleBorder()),
  );

  // @override
  // State<_Button> createState() => _ButtonState();

  IconData iconData();

  void onPressed();

  bool get enabled;
// }

// class _ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        size: _Button.buttonSize,
        child: GetItListenableBuilder<PlayerStateNotifer, PlayerState>(
          builder: (context, _) {
            return IconButton(
                style: _Button.style,
                onPressed: !enabled ? null : onPressed,
                icon: Icon(
                  iconData(),
                  color: Colors.white,
                ));
          },
        ));
  }
}

class PlayerNextButton extends _Button {
  const PlayerNextButton({super.key});

  @override
  IconData iconData() => Icons.skip_next_rounded;

  @override
  void onPressed() {
    getIt.playerRepository.let<void>((it) {
      it.saveProgress();
      it.nextEpisode();
    });
  }

  @override
  bool get enabled => getIt.playerRepository.isNextEpisodeAvailable();
}

class PlayerPreviousButton extends _Button {
  const PlayerPreviousButton({super.key});

  @override
  IconData iconData() => Icons.skip_previous_rounded;

  @override
  void onPressed() {
    getIt.playerRepository.let<void>((it) {
      it.saveProgress();
      it.previousEpisode();
    });
  }

  @override
  bool get enabled => getIt.playerRepository.isPreviousEpisodeAvailable();
}
