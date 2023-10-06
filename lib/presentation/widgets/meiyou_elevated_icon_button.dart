import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class MeiyouElevatedIconButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final double? height;
  final double? width;
  // final Color? iconColor;
  final TextStyle? textStyle;
  final VoidCallback onTap;
  // final double? fontSize;

  const MeiyouElevatedIconButton(
      {super.key,
      required this.text,
      required this.icon,
      // this.iconColor,
      this.textStyle,
      this.height,
      this.width,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          maximumSize: MaterialStatePropertyAll(Size(context.screenWidth, 50)),
          minimumSize: MaterialStatePropertyAll(Size(context.screenWidth, 50)),
          iconSize: const MaterialStatePropertyAll(25),
          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
          elevation: const MaterialStatePropertyAll(0.0),
          iconColor:
              MaterialStatePropertyAll(context.theme.colorScheme.onSurface),
          alignment: Alignment.centerLeft,
          overlayColor: MaterialStatePropertyAll(
              context.theme.colorScheme.brightness == Brightness.dark
                  ? Colors.white24
                  : Colors.black26)),
      onPressed: onTap,
      icon: icon,
      label: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(text,
            style: textStyle ??
                TextStyle(
                    inherit: true,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: context.theme.colorScheme.onSurface)),
      ),
    );
  }
}
