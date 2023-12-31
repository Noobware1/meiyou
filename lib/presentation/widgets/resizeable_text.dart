import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class ResizeableTextWidget extends StatefulWidget {
  final String text;
  final bool showButtons;
  final int maxLines;
  final TextStyle style;
  const ResizeableTextWidget(
      {required this.text,
      required this.maxLines,
      this.showButtons = false,
      this.style = const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
      super.key});

  @override
  State<ResizeableTextWidget> createState() => _ResizeableTextWidgetState();
}

class _ResizeableTextWidgetState extends State<ResizeableTextWidget> {
  bool showFullText = false;
  late final TextPainter tp;
  late final TextPainter tp2;
  @override
  void initState() {
    final textSpan = TextSpan(style: widget.style, text: widget.text);
    tp = TextPainter(textDirection: TextDirection.ltr, text: textSpan);
    tp2 = TextPainter(
        textDirection: TextDirection.ltr,
        text: textSpan,
        maxLines: widget.maxLines);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      tp2.layout(maxWidth: width);
      tp.layout(maxWidth: width);

      final defaultHeight = tp2.height;
      final height = tp.height;

      final renderText = _renderText(showFullText ? height + 20 : defaultHeight,
          showFullText ? null : widget.maxLines);
      if (widget.showButtons) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            renderText,
            if (defaultHeight != height) _button(showFullText),
          ],
        );
      } else {
        return GestureDetector(onTap: handleOnTap, child: renderText);
      }
    });
  }

  void handleOnTap() {
    if (showFullText) {
      setState(() {
        showFullText = false;
      });
    } else {
      setState(() {
        showFullText = true;
      });
    }
  }

  Widget _button(bool showFullText) => Builder(builder: (context) {
        return Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(20),
          animationDuration: animationDuration,
          child: InkWell(
            splashColor: context.theme.colorScheme.primary,
            onTap: handleOnTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                showFullText ? 'Read less' : 'Read more',
                style: TextStyle(
                    color: context.theme.colorScheme.primary, fontSize: 16),
              ),
            ),
          ),
        );
      });

  Widget _renderText(double height, int? maxLines) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: context.screenWidth,
        child: Text(
          widget.text,
          style: widget.style,
          maxLines: maxLines,
          overflow: maxLines != null ? TextOverflow.ellipsis : null,
        ),
      );
}

class ResizebleTextWidgetNoAnimation extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  const ResizebleTextWidgetNoAnimation(
      {super.key, required this.text,
      required this.maxLines,
      this.style = const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)});

  @override
  State<ResizebleTextWidgetNoAnimation> createState() =>
      __ResizebleTextWidgetNoAnimationState();
}

class __ResizebleTextWidgetNoAnimationState
    extends State<ResizebleTextWidgetNoAnimation> {
  bool showFullText = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        if (showFullText) {
          showFullText = false;
        } else {
          showFullText = true;
        }
      }),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: !showFullText ? widget.maxLines : null,
        overflow: !showFullText ? TextOverflow.ellipsis : null,
      ),
    );
  }
}
