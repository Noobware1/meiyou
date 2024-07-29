import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class MediaScreenThemeData {
  abstract final double bannerHeight;
  abstract final double bannerWidth;
  abstract final BoxFit bannerFit;
  abstract final LinearGradient bannerGradient;
  abstract final double posterHeight;
  abstract final double posterWidth;
  abstract final BorderRadius posterBorderRadius;
  abstract final BoxFit posterFit;
  abstract final double posterPosition;
  abstract final EdgeInsets defaultPadding;
  abstract final double stackHeight;
  abstract final BoxConstraints mediaRowConstraints;
  abstract final MainAxisAlignment titleMainAxisAlignment;
  abstract final EdgeInsets titleBoxPadding;
  abstract final TextStyle titleTextStyle;
  abstract final TextStyle statusTextStyle;
  abstract final ButtonStyle buttonStyle;
  abstract final ButtonStyle unSelectedButtonStyle;
  abstract final MainAxisAlignment buttonMainAxisAlignment;
  abstract final BoxConstraints? buttonRowConstraints;
  abstract final double? rowSpacing;
  abstract final TextStyle descriptionTextStyle;
  abstract final TextStyle? descriptionLabelTextStyle;
  abstract final TextStyle metaDataTextStyle;
  abstract final Color metaDataIconColor;
  abstract final VisualDensity genreVisualDensity;
  abstract final ChipThemeData genreChipTheme;
  abstract final double spacing;

  factory MediaScreenThemeData.forSize(
    BuildContext context,
    BoxConstraints constraints,
    ScreenSize size,
  ) {
    return size.whenDesktop(
      () => MediaScreenThemeDataDesktop(context, constraints),
      orElse: () => MediaScreenThemeDataMobile(context, constraints),
    );
  }
}

abstract mixin class _MediaScreenThemDataCommonMixin
    implements MediaScreenThemeData {
  abstract final BuildContext _context;
  abstract final BoxConstraints _constraints;

  late final ColorScheme _colorScheme = _context.theme.colorScheme;

  late final TextTheme _textTheme = _context.theme.textTheme;

  @override
  BoxFit get bannerFit => BoxFit.cover;

  @override
  LinearGradient get bannerGradient => [
        _colorScheme.surface,
        _colorScheme.surface.withOpacity(0.8),
        _colorScheme.surface.withOpacity(0.5),
        _colorScheme.surface.withOpacity(0.2),
      ].let((it) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                it[0],
                it[0],
                it[1],
                it[1],
                it[2],
                it[2],
                it[3],
                it[3],
              ]));

  @override
  double get posterPosition => 0.0;

  @override
  double get bannerWidth => _constraints.maxWidth;

  @override
  BoxConstraints get mediaRowConstraints => BoxConstraints(
        maxHeight: posterHeight,
        maxWidth: bannerWidth - defaultPadding.horizontal,
      );

  @override
  BorderRadius get posterBorderRadius => BorderRadius.circular(8.0);

  @override
  BoxFit get posterFit => BoxFit.fill;

  @override
  Color get metaDataIconColor => MaterialTheme.disabledButtonColor(_context);

  TextStyle get genreTextStyle;

  @override
  ChipThemeData get genreChipTheme => ChipThemeData(
        labelStyle: genreTextStyle.copyWith(
          color: _colorScheme.primary,
        ),
        side: BorderSide(color: _colorScheme.primary),
      );
}

final class MediaScreenThemeDataMobile with _MediaScreenThemDataCommonMixin {
  MediaScreenThemeDataMobile(BuildContext context, BoxConstraints constraints)
      : _context = context,
        _constraints = constraints;

  @override
  final BoxConstraints _constraints;

  @override
  final BuildContext _context;

  @override
  double get bannerHeight => 300;

  @override
  EdgeInsets get defaultPadding => const EdgeInsets.symmetric(horizontal: 10);

  @override
  double get posterHeight => defaultPosterHeightSmall;

  @override
  double get posterWidth => defaultPosterWidthSmall;

  @override
  double get stackHeight => bannerHeight + 20;

  @override
  TextStyle get statusTextStyle => _textTheme.bodyLarge!.copyWith(
        color: _context.theme.colorScheme.primary,
      );

  @override
  EdgeInsets get titleBoxPadding => const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      );

  @override
  MainAxisAlignment get titleMainAxisAlignment => MainAxisAlignment.end;

  @override
  TextStyle get titleTextStyle => _textTheme.titleLarge!;

  @override
  ButtonStyle get buttonStyle => ButtonStyle(
        iconColor: WidgetStatePropertyAll(_colorScheme.primary),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.all(8.0),
        ),
        textStyle: WidgetStatePropertyAll(
          _textTheme.bodySmall!.copyWith(
            color: _colorScheme.primary,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

  @override
  ButtonStyle get unSelectedButtonStyle => ButtonStyle(
        iconColor:
            WidgetStatePropertyAll(MaterialTheme.disabledButtonColor(_context)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.all(8.0),
        ),
        textStyle: WidgetStatePropertyAll(
          _textTheme.bodySmall!.copyWith(
            color: MaterialTheme.disabledButtonColor(_context),
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

  @override
  MainAxisAlignment get buttonMainAxisAlignment =>
      MainAxisAlignment.spaceAround;

  @override
  BoxConstraints? get buttonRowConstraints => null;

  @override
  double? get rowSpacing => null;

  @override
  TextStyle get descriptionTextStyle => _textTheme.bodyMedium!;

  @override
  TextStyle? get descriptionLabelTextStyle => null;

  @override
  TextStyle get metaDataTextStyle => descriptionTextStyle;

  @override
  VisualDensity get genreVisualDensity =>
      const VisualDensity(horizontal: -4, vertical: -2);

  @override
  TextStyle get genreTextStyle => _textTheme.bodySmall!;

  @override
  double get spacing => 8.0;
}

final class MediaScreenThemeDataDesktop with _MediaScreenThemDataCommonMixin {
  MediaScreenThemeDataDesktop(BuildContext context, BoxConstraints constraints)
      : _context = context,
        _constraints = constraints;

  @override
  final BoxConstraints _constraints;

  @override
  final BuildContext _context;

  @override
  double get bannerHeight => 400;

  @override
  EdgeInsets get defaultPadding =>
      EdgeInsets.symmetric(horizontal: _constraints.maxWidth / 10);

  @override
  double get posterHeight => 260;

  @override
  double get posterWidth => 180;

  @override
  double get stackHeight => bannerHeight + (posterHeight / 4);

  @override
  TextStyle get statusTextStyle => _textTheme.titleMedium!.copyWith(
        color: _context.theme.colorScheme.primary,
      );

  @override
  EdgeInsets get titleBoxPadding => const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      );

  @override
  MainAxisAlignment get titleMainAxisAlignment => MainAxisAlignment.center;

  @override
  TextStyle get titleTextStyle => _textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );

  @override
  ButtonStyle get buttonStyle => ButtonStyle(
        iconColor: WidgetStatePropertyAll(_colorScheme.primary),
        textStyle: WidgetStatePropertyAll(
          _textTheme.bodyMedium!.copyWith(
            color: _colorScheme.primary,
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.all(12.0),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: _colorScheme.primary,
            width: 1.0,
          ),
        ),
      );

  @override
  ButtonStyle get unSelectedButtonStyle {
    final disabledColor = MaterialTheme.disabledButtonColor(_context);

    return ButtonStyle(
      iconColor: WidgetStatePropertyAll(disabledColor),
      textStyle: WidgetStatePropertyAll(
        _textTheme.bodyMedium!.copyWith(
          color: disabledColor,
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.all(12.0),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: disabledColor,
          width: 1.0,
        ),
      ),
    );
  }

  @override
  MainAxisAlignment get buttonMainAxisAlignment => MainAxisAlignment.start;

  @override
  BoxConstraints get buttonRowConstraints => const BoxConstraints(
        maxWidth: 270,
      );

  @override
  double? get rowSpacing => 15;

  @override
  TextStyle get descriptionTextStyle => _textTheme.bodyLarge!;

  @override
  TextStyle get descriptionLabelTextStyle => _textTheme.titleLarge!;

  @override
  TextStyle get metaDataTextStyle => _textTheme.bodyLarge!;

  @override
  VisualDensity get genreVisualDensity => VisualDensity.compact;

  @override
  TextStyle get genreTextStyle => _textTheme.bodyMedium!;

  @override
  double get spacing => 16.0;
}
