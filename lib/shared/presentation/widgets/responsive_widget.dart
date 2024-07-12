import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';

typedef PlatformWidgetBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints, ScreenSize screenSize);

class ResponsiveBuilder extends StatelessWidget {
  final PlatformWidgetBuilder builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (Platform.isAndroid || Platform.isIOS) {
            final screenSize = context.screenSize;
            return builder(context, constraints, screenSize);
          } else {
        
            return builder(context, constraints, ScreenSize.desktop);
          }
        },
      );
    });
  }
}
