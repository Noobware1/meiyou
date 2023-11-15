import 'package:flutter/material.dart';

getBackgroundColorBasedOnBrightness(Brightness brightness ) {
  if (brightness == Brightness.dark) {
    return Colors.white;
  }
  return Colors.black;
}

getTexColorBasedOnBrightness(Brightness brightness ) {
  if (brightness == Brightness.dark) {
    return Colors.black;
  }
  return Colors.white;
}

getIconColorBasedOnBrightness(Brightness brightness ) {
  if (brightness == Brightness.dark) {
    return Colors.black;
  }
  return Colors.white;
}
