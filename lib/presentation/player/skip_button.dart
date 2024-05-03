import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/player/player_screen.dart';

class PlayerSkipButton extends StatelessWidget {
  const PlayerSkipButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('+85 s'),
    );
  }

  void onPressed() {
    InjectKtor.playerRepository.skip(85);
  }
}
