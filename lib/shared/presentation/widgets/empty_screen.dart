import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:nice_dart/nice_dart.dart';

extension<T> on List<T> {
  T getRandom() {
    return this[Random().nextInt(length)];
  }
}

/// A widget that displays a message when there is no data to show.
class EmptyScreen extends StatelessWidget {
  final String text;

  const EmptyScreen({
    super.key,
    required this.text,
  });

  static const emotIcons = [
    "(･o･;)",
    "Σ(ಠ_ಠ)",
    "ಥ_ಥ",
    "(˘･_･˘)",
    "(；￣Д￣)",
    "(･Д･。",
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      final width = constraints.maxWidth;

      final maxWidth = screenSize.when(
          mobile: () => width,
          tablet: () => width,
          desktop: () => max(width * 0.5, 600.0));

      final (iconTextStyle, textStyle) = context.theme.textTheme.let((it) {
        return (
          it.titleLarge,
          it.bodyMedium,
        );
      });

      final emoticon = emotIcons.getRandom();

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              emoticon,
              style: iconTextStyle,
            ),
          ),
          Center(
            child: Container(
              width: maxWidth,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    text,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
