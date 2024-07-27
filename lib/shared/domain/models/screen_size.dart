import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/size_constants.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop;

  static ScreenSize getScreenSize(Size size) {
    final width = size.width;
    if (width < 600) {
      return ScreenSize.mobile;
    }
    if (width < 840) {
      return ScreenSize.tablet;
    }
    return ScreenSize.desktop;
  }

  T when<T>({
    required T Function() mobile,
    required T Function() tablet,
    required T Function() desktop,
  }) {
    switch (this) {
      case ScreenSize.mobile:
        return mobile();
      case ScreenSize.tablet:
        return tablet();
      case ScreenSize.desktop:
        return desktop();
    }
  }

  T whenDesktop<T>(T Function() desktop, {required T Function() orElse}) {
    if (isDesktop) return desktop();
    return orElse();
  }

  T whenMobile<T>(T Function() mobile, {required T Function() orElse}) {
    if (isMobile) return mobile();
    return orElse();
  }

  T whenTablet<T>(T Function() tablet, {required T Function() orElse}) {
    if (isTablet) return tablet();
    return orElse();
  }

  bool get isMobile => this == ScreenSize.mobile;
  bool get isTablet => this == ScreenSize.tablet;
  bool get isDesktop => this == ScreenSize.desktop;
}
