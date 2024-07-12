library more;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';

part 'more_screen_mobile.dart';
part 'more_screen_desktop.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const mobile = _MoreScreenMobile();
  static const desktop = _MoreScreenDesktop();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.screenSize.isMobile;
    if (isMobile) return mobile;
    return desktop;
  }
}
