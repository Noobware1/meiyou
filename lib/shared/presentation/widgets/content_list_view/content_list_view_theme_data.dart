import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

abstract class ContentListViewThemeData {
  ContentListViewThemeData(BuildContext context) : _context = context;

  final BuildContext _context;

  late final TextTheme _textTheme = _context.theme.textTheme;

  abstract final TextStyle titleTextStyle;

  abstract final double mainAxisExtent;

  final double maxCrossAxisExtent = 250;

  final double crossAxisSpacing = 10;

  final double mainAxisSpacing = 10;
}

class ContentListViewThemeDataDesktop extends ContentListViewThemeData {
  ContentListViewThemeDataDesktop(super.context);

  @override
  TextStyle get titleTextStyle => _textTheme.titleMedium!;

  @override
  double get mainAxisExtent => 250;
}

class ContentListViewThemeDataMobile extends ContentListViewThemeData {
  ContentListViewThemeDataMobile(super.context);

  @override
  TextStyle get titleTextStyle => _textTheme.titleSmall!;

  @override
  double get mainAxisExtent => 170;
}

class ContentListViewThemeDataTablet extends ContentListViewThemeDataMobile {
  ContentListViewThemeDataTablet(super.context);

  @override
  double get mainAxisExtent => 210;
}
