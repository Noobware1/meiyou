import 'package:flutter/material.dart';

import 'constraints_box_for_large_screen.dart';
import 'layout_builder.dart';

class SelectedSearchResponseWidget extends StatelessWidget {
  final String title;
  const SelectedSearchResponseWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final child = Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
    return ResponsiveBuilder(
        forSmallScreen: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: child,
        ),
        forLagerScreen: ConstarintsForBiggerScreeen(
          child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 20),
              child: child),
        ));
  }
}
