import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/player_utils.dart';

class SeeekAnimation extends StatelessWidget {
  final AnimationController controller;
  final bool forward;
  const SeeekAnimation({
    super.key,
    required this.controller,
    required this.forward,
  });

  // static const aniamtionDuration = Duration(milliseconds: 800);

  @override
  Widget build(BuildContext context) {
    final animationDuration = theme(context).rewindForwardAnimationDuration;
    return Padding(
      padding: isMobile
          ? const EdgeInsets.only(top: 40.0)
          : const EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            forward ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Icon(
            forward ? Icons.fast_forward_rounded : Icons.fast_rewind_rounded,
            color: Colors.white,
            size: theme(context).playButtonSize,
          ),
          DefaultTextStyle(
              style: const TextStyle(color: Colors.white, fontSize: 20),
              child: Text(forward ? '+ 10' : '- 10')),
        ],
      )
          .animate(
            controller: controller,
            autoPlay: false,
          )
          .slide(
              begin: const Offset(0.0, 0.0),
              end: forward ? const Offset(3.0, 0) : const Offset(-3.0, 0),
              duration: animationDuration)
          .fade(begin: 0.0, end: 1.0, duration: animationDuration),
    );
  }
}
