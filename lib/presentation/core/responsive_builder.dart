import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';

class ResponseBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints boxConstraints,
    ScreenSize screenSize,
  ) builder;

  const ResponseBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return builder(
          context,
          boxConstraints,
          ScreenSize.fromWidth(boxConstraints.maxWidth),
        );
      },
    );
  }
}
