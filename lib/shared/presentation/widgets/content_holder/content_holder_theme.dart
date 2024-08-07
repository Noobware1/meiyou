import 'package:flutter/material.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder_theme_data.dart';
import 'package:meiyou/shared/presentation/widgets/inherited_resposive_theme.dart';

class ContentHolderTheme extends InheritedResposiveTheme {
  final ContentHolderThemeDataMobile mobileData;
  final ContentHolderThemeDataTablet tabletData;
  final ContentHolderThemeDataDesktop desktopData;

  const ContentHolderTheme({
    super.key,
    required super.screenSize,
    required this.mobileData,
    required this.tabletData,
    required this.desktopData,
    required super.child,
  });

  ContentHolderTheme.fromContext({
    super.key,
    required super.child,
    required super.screenSize,
    required BuildContext context,
  })  : mobileData = ContentHolderThemeDataMobile(context),
        tabletData = ContentHolderThemeDataTablet(context),
        desktopData = ContentHolderThemeDataDesktop(context);

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ContentHolderTheme(
      screenSize: screenSize,
      mobileData: mobileData,
      tabletData: tabletData,
      desktopData: desktopData,
      child: child,
    );
  }

  static ContentHolderThemeData of(BuildContext context) {
    final ContentHolderTheme? theme =
        context.dependOnInheritedWidgetOfExactType<ContentHolderTheme>();
    return theme!.screenSize.when(
      desktop: () => theme.desktopData,
      tablet: () => theme.tabletData,
      mobile: () => theme.mobileData,
    );
  }
}
