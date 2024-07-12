import 'package:meiyou/core/utils/constants/size_constants.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop;

  static ScreenSize getScreenSize(double size) {
    if (size < mobileScreenSize) {
      return ScreenSize.mobile;
    } else if (size < tabletScreenSize) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
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

  bool get isMobile => this == ScreenSize.mobile;
  bool get isTablet => this == ScreenSize.tablet;
  bool get isDesktop => this == ScreenSize.desktop;
}
