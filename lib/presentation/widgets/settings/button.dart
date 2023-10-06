import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'dart:math' as math show pi;

class ArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String? snackBarString;
  const ArrowButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.snackBarString});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.button,
      child: InkWell(
        onTap: onTap,
        onLongPress: () {
          if (snackBarString != null) {
            showSnackBAr(context, text: snackBarString!);
          }
        },
        child: Container(
          width: context.screenWidth,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultTextStyle(
                      style: TextStyle(
                          color: context.theme.colorScheme.onBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      child: Text(text),
                    ),
                  ),
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
