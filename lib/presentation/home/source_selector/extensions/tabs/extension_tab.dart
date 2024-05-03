import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/resources/platform.dart';

abstract interface class ExtensionTab<Type> {
  static const headerPadding =
      EdgeInsets.only(left: 25, top: 15, bottom: 15, right: 25);

  static const headerTextStyleMobile = TextStyle(
    fontSize: MobileFontSize.medium,
    fontWeight: FontWeight.w500,
  );

  static const headerTextStyleDekstop = TextStyle(
    fontSize: DesktopFontSize.medium,
    fontWeight: FontWeight.w500,
  );

  static titleTextStyle() {
    return isMobile ? headerTextStyleMobile : headerTextStyleDekstop;
  }

  Widget itemBuilder(
      BuildContext context, int index, Map<String, List<Type>> state);

  List<Widget> children(MapEntry<String, List<Type>> entry);

  Widget header(String language);
}
