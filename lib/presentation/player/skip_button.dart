import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/presentation/player/player_screen.dart';

class PlayerSkipButton extends StatelessWidget {
  const PlayerSkipButton({super.key});
  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: const Text('+85 s'));
  }

  void onPressed() {
    getIt.playerRepository.skip(85);
  }
}
