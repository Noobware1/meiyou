import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class MeiyouElevatedIconButton extends StatelessWidget {
  final Widget child;
  final Icon icon;
  final double? height;
  final double? width;
  // final Color? iconColor;
  final EdgeInsets? padding;
  final VoidCallback onTap;
  // final double? fontSize;

  const MeiyouElevatedIconButton(
      {super.key,
      required this.icon,
      this.height,
      this.width,
      required this.onTap,
      this.padding,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          // maximumSize: MaterialStatePropertyAll(Size(context.screenWidth, 50)),
          // minimumSize: MaterialStatePropertyAll(Size(context.screenWidth, 50)),
          iconSize: const MaterialStatePropertyAll(30),
          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
          elevation: const MaterialStatePropertyAll(0.0),
          iconColor:
              MaterialStatePropertyAll(context.theme.colorScheme.onSurface),
          padding: MaterialStatePropertyAll(padding),
          alignment: Alignment.centerLeft,
          overlayColor: MaterialStatePropertyAll(
              context.theme.colorScheme.brightness == Brightness.dark
                  ? Colors.white24
                  : Colors.black26)),
      onPressed: onTap,
      icon: icon,
      label:
          // Padding(
          // padding: const EdgeInsets.only(left: 20),
          // child:
          child,
      // ),
    );
  }
}
