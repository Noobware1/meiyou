
import 'package:flutter/material.dart';

import 'image_holder.dart';

class ImageHolderButtonWrapper extends StatefulWidget {
  final VoidCallback callback;
  final ImageHolder imageHolder;

  const ImageHolderButtonWrapper({
    super.key,
    required this.imageHolder,
    required this.callback,
  });

  @override
  State<ImageHolderButtonWrapper> createState() =>
      _ImageHolderButtonWrapperState();
}

class _ImageHolderButtonWrapperState extends State<ImageHolderButtonWrapper> {
  double opacity = 0.0;

  void setOpacity() {
    setState(() {
      if (opacity == 0.0) {
        opacity = 1.0;
      } else {
        opacity = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setOpacity();
        widget.callback();
      },
      onLongPress: setOpacity,
      child: Center(
          child: Stack(children: [
        widget.imageHolder,
        AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 200),
          onEnd: () => setState(() {
            opacity = 0.0;
          }),
          child: Container(
            height: widget.imageHolder.imageHeight,
            width: widget.imageHolder.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        )
      ])),
    );
  }
}
