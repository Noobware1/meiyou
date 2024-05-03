import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/resources/platform.dart';

abstract class ExtensionTile extends StatelessWidget {
  static const titleTextStyleMobile = TextStyle(
    fontSize: MobileFontSize.normal,
    fontWeight: FontWeight.w500,
  );

  static const subtitleTextStyleMobile = TextStyle(
    fontSize: MobileFontSize.small,
    fontWeight: FontWeight.w400,
  );

  static const titleTextStyleDesktop = TextStyle(
    fontSize: MobileFontSize.normal,
    fontWeight: FontWeight.w500,
  );

  static const subtitleTextStyleDesktop = TextStyle(
    fontSize: MobileFontSize.small,
    fontWeight: FontWeight.w400,
  );

  TextStyle titleTextStyle() {
    return isMobile ? titleTextStyleMobile : titleTextStyleDesktop;
  }

  TextStyle subtitleTextStyle() {
    return isMobile ? subtitleTextStyleMobile : subtitleTextStyleDesktop;
  }

  const ExtensionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title(),
      subtitle: subtitle(),
      leading: icon(),
      trailing: button(),
      onTap: onPressed,
    );
  }

  Widget title();

  Widget subtitle();

  void onPressed();

  Widget icon();

  Widget button();
}
