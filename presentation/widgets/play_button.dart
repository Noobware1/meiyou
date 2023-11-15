import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';

class PlayButton extends StatelessWidget {
  final double height;
  final VoidCallback? onTap;
  const PlayButton({
    super.key,
    required this.height,
    this.onTap,
  });

  static const _border = CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: animationDuration,
      shape: _border,
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: _border,
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: height / 2.16,
          ),
        ),
      ),
    );
  }
}
