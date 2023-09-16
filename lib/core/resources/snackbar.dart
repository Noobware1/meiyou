import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

void showSnackBAr(BuildContext context, {required String text, double? width}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    backgroundColor: Colors.black,
    //  duration: const Duration(milliseconds: 300),
    elevation: 10.0,
    //elevation: 1,
    //margin: const EdgeInsets.all(40),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    width: width ?? context.screenWidth / 1.2,

    behavior: SnackBarBehavior.floating,
  ));
}
