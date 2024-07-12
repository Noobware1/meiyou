import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

class Button extends StatelessWidget {
  final double? height;
  final double? width;
  final String text;
  final bool enabled;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final double textSize;
  final ButtonStyle? style;
  // final TextStyle? textStyle;

  const Button({
    super.key,
    this.width,
    this.height,
    this.enabled = true,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.color,
    this.textColor,
    this.textSize = 14,
    this.disabledColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final fixedSize = Size(width ?? context.width, height ?? 40);

    return FilledButton(
      onPressed: !enabled ? null : (onPressed ?? () {}),
      onLongPress: !enabled ? null : (onLongPress ?? () {}),
      style: style?.copyWith(
            backgroundColor: MaterialStatePropertyAll(color),
            fixedSize: MaterialStatePropertyAll(fixedSize),
          ) ??
          ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(color),
            fixedSize: MaterialStatePropertyAll(fixedSize),
          ),
      child: Text(text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
