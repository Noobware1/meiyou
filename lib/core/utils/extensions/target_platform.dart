import 'package:flutter/material.dart';

extension TargetPlatformExt on TargetPlatform {
  bool get isMobile =>
      this == TargetPlatform.android || this == TargetPlatform.iOS;
}
