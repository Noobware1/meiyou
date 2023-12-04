import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/screen_size.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget forSmallScreen;
  final Widget forBiggerScreen;
  final double diff;
  const ResponsiveLayout(
      {super.key,
      required this.forSmallScreen,
      required this.forBiggerScreen,
      this.diff = mobileScreenSize});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // print(constraints.maxWidth);
      if (constraints.maxWidth <= diff) return forSmallScreen;
      return forBiggerScreen;
    });
  }

  static builder({
    required Widget Function(BuildContext context, BoxConstraints constraints)
        forSmallScreen,
    required Widget Function(BuildContext context, BoxConstraints constraints)
        forBiggerScreen,
    double diff = mobileScreenSize,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= diff) {
        return forSmallScreen(context, constraints);
      }
      return forBiggerScreen(context, constraints);
    });
  }
}
