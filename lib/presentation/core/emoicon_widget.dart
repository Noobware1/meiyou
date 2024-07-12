import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/core/responsive_builder.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:nice_dart/nice_dart.dart';

extension<T> on List<T> {
  T getRandom() {
    return this[Random().nextInt(length)];
  }
}

class EmoticonsWidget extends StatelessWidget {
  final String? emoticon;
  final String text;
  // final List<Widget> Function(BuildContext context, BoxConstraints constraints)?
  //     children;

  const EmoticonsWidget({
    super.key,
    required this.text,
    this.emoticon,
    // this.children,
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
    return ResponseBuilder(builder: (context, constraints, screenSize) {
      final maxWidth =
          screenSize.isMobile ? context.width : context.width * 0.5;
      final (iconTextStyle, textStyle) = context.theme.textTheme.let((it) {
        return (
          screenSize.isMobile ? it.displaySmall : it.bodyLarge,
          it.bodyMedium
        );
      });

      final verticalSpace = screenSize.isMobile ? 2.0 : 20.0;
      final emoticon = this.emoticon ?? emotIcons.getRandom();

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
          VerticalSpace(verticalSpace),
          Center(
            child: SizedBox(
              width: maxWidth,
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
