import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final bool animation;
  final int maxLines;
  final bool expanded;
  final void Function(bool)? onExpandedChanged;
  const ExpandableText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.animation = true,
    this.maxLines = 3,
    this.expanded = false,
    this.animationCurve,
    this.animationDuration,
    this.onExpandedChanged,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
  }

  void onTap() {
    setState(() {
      _expanded = !_expanded;
      widget.onExpandedChanged?.call(_expanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final content = TextSpan(text: widget.text, style: effectiveTextStyle);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          assert(constraints.hasBoundedWidth);
          final double maxWidth = constraints.maxWidth;

          final textAlign =
              widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
          final textDirection =
              widget.textDirection ?? Directionality.of(context);
          final textScaler =
              widget.textScaler ?? MediaQuery.textScalerOf(context);
          final locale = Localizations.maybeLocaleOf(context);

          final textPainter = TextPainter(
            text: content,
            textAlign: textAlign,
            textDirection: textDirection,
            textScaler: textScaler,
            locale: locale,
            maxLines: widget.maxLines,
          );
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: maxWidth);
          final textSize = textPainter.size;

          TextSpan textSpan;
          if (textPainter.didExceedMaxLines) {
            final position = textPainter.getPositionForOffset(Offset(
              textSize.width,
              textSize.height,
            ));
            final endOffset = textPainter.getOffsetBefore(position.offset) ?? 0;
            final text = TextSpan(
              text: _expanded
                  ? widget.text
                  : widget.text.substring(0, max(endOffset, 0)),
            );

            textSpan = TextSpan(
              style: effectiveTextStyle,
              children: <TextSpan>[
                text,
              ],
            );
          } else {
            textSpan = content;
          }

          Widget richText = RichText(
            text: textSpan,
            softWrap: true,
            textDirection: textDirection,
            textAlign: textAlign,
            textScaler: textScaler,
            overflow: TextOverflow.clip,
          );

          if (!context.theme.platform.isMobile) {
            richText = SelectableText.rich(
              textSpan,
              // softWrap: true,
              textDirection: textDirection,
              textAlign: textAlign,
              textScaler: textScaler,

              // overflow: TextOverflow.clip,
            );
          }

          if (widget.animation) {
            return AnimatedSize(
              duration:
                  widget.animationDuration ?? const Duration(milliseconds: 200),
              curve: widget.animationCurve ?? Curves.fastLinearToSlowEaseIn,
              alignment: Alignment.topLeft,
              child: richText,
            );
          }

          return richText;
        }),
      ),
    );
  }
}
