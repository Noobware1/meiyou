import 'package:flutter/material.dart';

class ResponseBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints boxConstraints,
    bool isSmallScreen,
  ) builder;

  const ResponseBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return builder(context, boxConstraints, boxConstraints.maxWidth < 600);
      },
    );
  }
}
