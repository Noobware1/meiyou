import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/space.dart';

extension on Widget {
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }
}

class Section extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final List<Widget> children;
  final EdgeInsets? titlePadding;
  const Section({
    super.key,
    required this.title,
    this.titleTextStyle,
    required this.children,
    this.titlePadding,
  });

  static const defaultPadding = EdgeInsets.all(18);

  @override
  Widget build(BuildContext context) {
    // final themeState = themeNotifer.state;
    // final brighteness = context.brightness;
    final titleTextStyle = this.titleTextStyle ??
        TextStyle(
          fontSize: MobileFontSize.normal,
          fontWeight: FontWeight.w600,
          color: context.theme.colorScheme.primary,
        );

    final titlePadding = this.titlePadding ?? defaultPadding;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleTextStyle).padding(titlePadding),
        for (final child in children) child
      ],
    );
  }
}

class IgnoreSectionPadding extends StatelessWidget {
  final EdgeInsets? newPadding;
  final Widget child;
  const IgnoreSectionPadding({super.key, required this.child, this.newPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: newPadding ?? EdgeInsets.zero, child: child);
  }
}
