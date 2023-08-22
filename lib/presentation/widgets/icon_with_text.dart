import 'package:flutter/material.dart';

class IconButtonWithText extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback onTap;
  const IconButtonWithText(
      {super.key, required this.icon, required this.onTap, required this.text});

  static const _border = CircleBorder(eccentricity: 1.0);

  @override
  Widget build(BuildContext context) {
    final defaultSize = icon.size ?? 30;
    return SizedBox(
      height: defaultSize + 30,
      width: defaultSize + 50,
      child: Material(
        type: MaterialType.transparency,
        shape: _border,
        animationDuration: const Duration(milliseconds: 100),
        child: InkWell(
          onTap: onTap,
          customBorder: _border,
          child: Column(
            children: [
              icon,
              Expanded(
                child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    child: Text(text)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
