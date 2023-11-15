import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class ConstarintsForBiggerScreeen extends StatelessWidget {
  final Widget child;
  const ConstarintsForBiggerScreeen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.screenWidth / 2),
      child: child,
    );
  }
}
