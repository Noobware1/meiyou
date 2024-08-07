import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view_theme_data.dart';
import 'package:meiyou/shared/presentation/widgets/inherited_resposive_theme.dart';

class ContentListViewTheme extends InheritedResposiveTheme {
  const ContentListViewTheme({
    super.key,
    required super.child,
    required super.screenSize,
    required this.mobileData,
    required this.tabletData,
    required this.desktopData,
  });

  ContentListViewTheme.fromContext({
    super.key,
    required super.child,
    required super.screenSize,
    required BuildContext context,
  })  : mobileData = ContentListViewThemeDataMobile(context),
        tabletData = ContentListViewThemeDataTablet(context),
        desktopData = ContentListViewThemeDataDesktop(context);

  final ContentListViewThemeDataMobile mobileData;
  final ContentListViewThemeDataTablet tabletData;
  final ContentListViewThemeDataDesktop desktopData;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ContentListViewTheme(
      screenSize: screenSize,
      mobileData: mobileData,
      tabletData: tabletData,
      desktopData: desktopData,
      child: child,
    );
  }

  static ContentListViewThemeData of(BuildContext context) {
    final ContentListViewTheme theme =
        context.dependOnInheritedWidgetOfExactType<ContentListViewTheme>()!;
    return theme.screenSize.when(
      desktop: () => theme.desktopData,
      tablet: () => theme.tabletData,
      mobile: () => theme.mobileData,
    );
  }
}
