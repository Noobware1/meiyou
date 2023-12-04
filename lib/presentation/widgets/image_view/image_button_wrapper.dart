import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';

class ImageButtonWrapper extends StatelessWidget {
  final VoidCallback onTap;
  final ImageHolder child;
  const ImageButtonWrapper(
      {super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: child.width,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Material(
                type: MaterialType.button,
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                animationDuration: animationDuration,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: onTap,
                )),
          ),
        ],
      ),
    );
  }
}
