import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart'
    show smallScreenSize;

class ResponsiveBuilder extends StatelessWidget {
  final Widget forSmallScreen;
  final Widget forLagerScreen;

  const ResponsiveBuilder(
      {super.key, required this.forSmallScreen, required this.forLagerScreen});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
    
      if (constraints.maxWidth < smallScreenSize) {
        return forSmallScreen;
      } else {
        return forLagerScreen;
      }
    });
  }
}
