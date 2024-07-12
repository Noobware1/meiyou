import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

typedef PlatformWidgetBuilder = Widget Function(
    BuildContext context, TargetPlatform platform);

class PlatformBuilder extends StatelessWidget {
  final PlatformWidgetBuilder builder;

  const PlatformBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final platform = context.theme.platform;
    return builder(context, platform);
  }
}
