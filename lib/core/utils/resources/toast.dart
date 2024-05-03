import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void makeToast(
  String message, {
  Duration duration = const Duration(seconds: 10),
  Alignment align = const Alignment(0, 0.99),
  dismissDirections = const [
    DismissDirection.horizontal,
    DismissDirection.down
  ],
}) {
  BotToast.showSimpleNotification(
    onlyOne: true,
    dismissDirections: dismissDirections,
    align: align,
    duration: duration,
    title: message,
    
  );
}
