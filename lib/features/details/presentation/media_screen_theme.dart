import 'package:flutter/material.dart';
import 'package:meiyou/features/details/domain/models/media_screen_theme_data.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';

class MediaScreenTheme extends InheritedTheme {
  final ScreenSize screenSize;
  final MediaScreenThemeDataMobile mobileData;
  final MediaScreenThemeDataDesktop desktopData;

  const MediaScreenTheme({
    super.key,
    required super.child,
    required this.screenSize,
    required this.mobileData,
    required this.desktopData,
  });

  @override
  bool updateShouldNotify(covariant MediaScreenTheme oldWidget) {
    return screenSize != oldWidget.screenSize;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MediaScreenTheme(
      screenSize: screenSize,
      mobileData: mobileData,
      desktopData: desktopData,
      child: child,
    );
  }

  static MediaScreenThemeData of(BuildContext context) {
    final MediaScreenTheme? theme =
        context.dependOnInheritedWidgetOfExactType<MediaScreenTheme>();
    return theme!.screenSize.whenDesktop(
      () => theme.desktopData,
      orElse: () => theme.mobileData,
    );
  }
}
