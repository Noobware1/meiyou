import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart' hide Gradient;
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/gradient.dart';

class ResizableText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final bool button;
  final bool animation;
  final int maxLines;
  const ResizableText({
    super.key,
    required String text,
    required this.textStyle,
    this.button = true,
    this.animation = true,
    this.maxLines = 3,
  }) : this.text = (button) ? '$text\n' : text;

  @override
  State<ResizableText> createState() => _ResizableTextState();
}

class _ResizableTextState extends State<ResizableText> {
  static const Duration animationDuration = Duration(milliseconds: 300);

  bool expanded = false;

  void onExpandedChanged([bool? value]) {
    setState(() {
      expanded = value ?? !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ExpandableText(
          widget.text,
          expandText: '',
          style: widget.textStyle,
          animation: widget.animation,
          maxLines: widget.maxLines,
          expanded: expanded,
          onExpandedChanged: onExpandedChanged,
          collapseOnTextTap: true,
          expandOnTextTap: true,
          animationDuration: animationDuration,
        ),
        if (!expanded)
          Positioned(
              right: 0,
              left: 0,
              child: IgnorePointer(
                  child: gradient(context.theme.scaffoldBackgroundColor))),
        if (widget.button) IgnorePointer(child: _button()),
      ],
    );
  }

  Widget _button() {
    return Builder(builder: (context) {
      return Container(
        alignment: Alignment.bottomCenter,
        width: 40,
        height: 30,
        child: RotatedBox(
          quarterTurns: expanded ? 3 : 1,
          child: Icon(Icons.arrow_forward_ios,
              color: context.theme.colorScheme.onSurface, size: 15),
        ),
      );
    });
  }

  Widget gradient(Color color) {
    return Gradient(
      height: 20,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        color,
        color.withOpacity(0.2),
      ],
    );
  }
}
