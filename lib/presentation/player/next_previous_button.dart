import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
// import 'package:media_kit/media_kit.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/player/cubits/player_cubit.dart';
import 'package:meiyou/presentation/player/player_screen.dart';

abstract class _Button extends StatefulWidget {
  const _Button({
    super.key,
  });

  static const buttonSize = Size(75.0, 75.0);
  static const ButtonStyle style = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(buttonSize),
    iconSize: MaterialStatePropertyAll(55.0),
    shape: MaterialStatePropertyAll(CircleBorder()),
  );

  @override
  State<_Button> createState() => _ButtonState();

  IconData iconData();

  void onPressed();

  bool get enabled;
}

class _ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: _Button.buttonSize,
      child: InjecktorBlocListener<PlayerCubit, PlayerState>(
        listener: (context, state) => setState(() {}),
        child: IconButton(
            style: _Button.style,
            onPressed: !widget.enabled ? null : widget.onPressed,
            icon: Icon(widget.iconData())),
      ),
    );
  }
}

class PlayerNextButton extends _Button {
  const PlayerNextButton({super.key});

  @override
  IconData iconData() => Icons.skip_next_rounded;

  @override
  void onPressed() {
    InjectKtor.playerRepository.nextEpisode();
  }

  @override
  bool get enabled => InjectKtor.playerRepository.isNextEpisodeAvailable();
}

class PlayerPreviousButton extends _Button {
  const PlayerPreviousButton({super.key});

  @override
  IconData iconData() => Icons.skip_previous_rounded;

  @override
  void onPressed() {
    InjectKtor.playerRepository.previousEpisode();
  }

  @override
  bool get enabled => InjectKtor.playerRepository.isPreviousEpisodeAvailable();
}
