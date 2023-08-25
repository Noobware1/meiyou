import 'package:flutter/material.dart';

void showSnackBAr(BuildContext context, {required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.black,
    content:
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
  ));
}
