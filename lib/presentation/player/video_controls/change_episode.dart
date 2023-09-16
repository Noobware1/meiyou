import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/player_utils.dart';

enum ChangeEpisodeIcon { previous, next }

class ChangeEpisode extends StatelessWidget {
  final ChangeEpisodeIcon icon;
  final VoidCallback onTap;
  const ChangeEpisode({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Icon(
        icon == ChangeEpisodeIcon.previous
            ? Icons.skip_previous
            : Icons.skip_next,
        size: theme(context).changeEpisodeButtonSize,
        color: Colors.white,
      ),
    );
  }
}
