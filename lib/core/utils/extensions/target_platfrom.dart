import 'package:flutter/material.dart';

extension TargetPlatfromExtensions on TargetPlatform {
  bool get isMobile {
    return this == TargetPlatform.android || this == TargetPlatform.iOS;
  }
}

