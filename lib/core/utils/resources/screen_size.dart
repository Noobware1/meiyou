// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

enum ScreenSize {
  Mobile,
  Desktop;

  bool get isMobile => this == ScreenSize.Mobile;

  bool get isDesktop => this == ScreenSize.Desktop;

  static ScreenSize fromWidth(double width) {
    if (width < 900) {
      return ScreenSize.Mobile;
    } else {
      return ScreenSize.Desktop;
    }
  }
}

extension GetScreenSizeFromContext on BuildContext {
  ScreenSize get screenSize => ScreenSize.fromWidth(width);
}
