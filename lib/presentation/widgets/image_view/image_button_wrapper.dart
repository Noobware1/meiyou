import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';

class ImageButtonWrapper extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const ImageButtonWrapper(
      {super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
              type: MaterialType.transparency,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              animationDuration: animationDuration,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: onTap,
              )),
        ),
      ],
    );
  }
}
