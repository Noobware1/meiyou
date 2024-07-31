import 'package:flutter/material.dart';

extension TargetPlatformExt on TargetPlatform {
  bool get isMobile =>
      this == TargetPlatform.android || this == TargetPlatform.iOS;

  T when<T>({
    required T Function() mobile,
    required T Function() desktop,
  }) {
    switch (this) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return mobile();
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        return desktop();
    }
  }
}
