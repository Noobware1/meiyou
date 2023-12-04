import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meiyou/core/resources/snackbar.dart';

void copyToClipBoard(BuildContext context, String data) {
  Clipboard.setData(ClipboardData(text: data)).then((value) {
    try {
      showSnackBar(context, text: 'Copied $data');
    } catch (_) {}
  });
}
