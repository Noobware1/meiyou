import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';

abstract class ContentHolderThemeData {
  ContentHolderThemeData(BuildContext context) : _context = context;

  final BuildContext _context;

  late final ColorScheme _colorScheme = _context.theme.colorScheme;

  late final TextTheme _textTheme = _context.theme.textTheme;

  factory ContentHolderThemeData.forSize(
      BuildContext context, ScreenSize screenSize) {
    return screenSize.when(
      desktop: () => ContentHolderThemeDataDesktop(context),
      tablet: () => ContentHolderThemeDataTablet(context),
      mobile: () => ContentHolderThemeDataMobile(context),
    );
  }

  static const _holderBorderRadius = BorderRadius.all(Radius.circular(15));

  static const _numberBorderRadius =
      BorderRadius.only(bottomRight: Radius.circular(15));

  static const _playButtonContainerHeight = 55.0;

  BorderRadius get numberBorderRadius => _numberBorderRadius;

  BorderRadius get holderBorderRadius => _holderBorderRadius;

  BorderRadius get gridImageBorderRadius => const BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15));

  BorderRadius get listImageBorderRadius => _holderBorderRadius;

  abstract final double listImageWidth;

  abstract final double listImageHeight;

  double get playButtonContainerHeight => _playButtonContainerHeight;

  double get playButtonIconSize => MaterialTheme.iconSize;

  Color get playButtonBackgroundColor => Colors.black.withOpacity(0.7);

  double get playButtonSize => MaterialTheme.iconButtonSize;

  EdgeInsets get playButtonPadding => const EdgeInsets.all(4);

  Color get playButtonColor => Colors.white;

  Color get numberBackgroundColor => _colorScheme.onPrimaryContainer;

  TextStyle get numberTextStyle => _textTheme.titleMedium!.copyWith(
        color: _colorScheme.surface,
        fontWeight: FontWeight.bold,
      );

  TextStyle get fillerTextStyle => _textTheme.titleSmall!.copyWith(
        color: _colorScheme.surface,
        fontStyle: FontStyle.italic,
      );

  BorderRadius get fillerBorderRadius =>
      const BorderRadius.only(bottomLeft: Radius.circular(15));

  abstract final double gridImageHeight;

  abstract final TextStyle titleTextStyle;

  abstract final TextStyle descriptionTextStyle;

  int maxTitleLines = 3;

  final Color fillerColor = Color(0xff4f3a35);
}

class ContentHolderThemeDataDesktop extends ContentHolderThemeData {
  ContentHolderThemeDataDesktop(super.context);

  @override
  double get gridImageHeight => 150.0;

  @override
  TextStyle get titleTextStyle => _textTheme.titleMedium!;

  @override
  TextStyle get descriptionTextStyle => _textTheme.bodyMedium!;

  @override
  double get listImageWidth => 200.0;

  @override
  double get listImageHeight => 120;
}

class ContentHolderThemeDataMobile extends ContentHolderThemeData {
  ContentHolderThemeDataMobile(super.context);

  @override
  double get gridImageHeight => 100.0;

  @override
  TextStyle get titleTextStyle => _textTheme.titleSmall!;

  @override
  TextStyle get descriptionTextStyle => _textTheme.bodySmall!;

  @override
  int get maxTitleLines => 2;

  @override
  double get listImageWidth => 160.0;

  @override
  double get listImageHeight => 100;
}

class ContentHolderThemeDataTablet extends ContentHolderThemeDataMobile {
  ContentHolderThemeDataTablet(super.context);

  @override
  double get gridImageHeight => 120.0;

  @override
  int get maxTitleLines => 3;

  @override
  double get listImageWidth => 180.0;
}
