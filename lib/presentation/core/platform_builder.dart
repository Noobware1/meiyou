import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/platform.dart';

class PlatformBuilder extends StatelessWidget {
  const PlatformBuilder(
      {super.key, required this.mobile, required this.desktop});

  final WidgetBuilder mobile;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return isMobile ? mobile(context) : desktop(context);
  }
}
