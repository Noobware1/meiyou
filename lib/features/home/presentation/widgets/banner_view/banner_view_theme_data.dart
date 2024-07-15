import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:nice_dart/nice_dart.dart';

final class BannerViewThemeData {
  final double bannerHeight;
  final double bannerHeightSmall;
  final BoxConstraints contentConstraints;
  final ButtonStyle navigationButtonStyle;
  final TextStyle titleTextStyle;
  final TextStyle titleTextStyleSmall;
  final TextStyle genreTextStyle;
  final TextStyle genreTextStyleSmall;
  final TextStyle descriptionTextStyleSmall;
  final TextStyle descriptionTextStyle;
  final Color gradientBaseColor;
  final LinearGradient bottomGradient;
  final LinearGradient sideGradient;
  final TextStyle genreSeparatorTextStyle;
  final EdgeInsets contentPadding;
  final EdgeInsets contentPaddingSmall;
  final double ratingIconSize;
  final Color ratingIconColor;

  TextStyle get ratingTextStyle => genreTextStyle;
  TextStyle get ratingTextStyleSmall => genreTextStyleSmall;

  final ButtonStyle bannerActionButtonStyle;
  final ButtonStyle bannerActionButtonStyleSmall;
  final ButtonStyle addToLibraryButtonStyle;
  final ButtonStyle addToLibraryButtonStyleSmall;

  double getBannerHeightForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop ? bannerHeight : bannerHeightSmall;
  }

  TextStyle getTextStyleForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? titleTextStyle
        : titleTextStyleSmall;
  }

  TextStyle getGenreTextStyleForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? genreTextStyle
        : genreTextStyleSmall;
  }

  TextStyle getDescriptionTextStyleForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? descriptionTextStyle
        : descriptionTextStyleSmall;
  }

  TextStyle getRatingTextStyleForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? ratingTextStyle
        : ratingTextStyleSmall;
  }

  EdgeInsets getContentPaddingForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? contentPadding
        : contentPaddingSmall;
  }

  ButtonStyle getActionButtonStyleForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? bannerActionButtonStyle
        : bannerActionButtonStyleSmall;
  }

  ButtonStyle getAddToLibraryButtonStyleForSize(ScreenSize screenSize) {
    return screenSize == ScreenSize.desktop
        ? addToLibraryButtonStyle
        : addToLibraryButtonStyleSmall;
  }

  BannerViewThemeData._({
    required this.descriptionTextStyle,
    required this.descriptionTextStyleSmall,
    required this.navigationButtonStyle,
    required this.gradientBaseColor,
    required this.bottomGradient,
    required this.sideGradient,
    required this.genreTextStyle,
    required this.genreTextStyleSmall,
    required this.titleTextStyle,
    required this.titleTextStyleSmall,
    required this.ratingIconSize,
    required this.ratingIconColor,
  })  : bannerHeight = 400,
        bannerHeightSmall = 360,
        contentConstraints = const BoxConstraints(maxWidth: 780),
        contentPadding = const EdgeInsets.all(8),
        contentPaddingSmall = const EdgeInsets.fromLTRB(8, 6, 8, 6),
        bannerActionButtonStyle = const ButtonStyle(
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 18, horizontal: 28)),
          elevation: WidgetStatePropertyAll(3.0),
        ),
        bannerActionButtonStyleSmall = const ButtonStyle(),
        addToLibraryButtonStyle = const ButtonStyle(
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 18, horizontal: 28)),
        ),
        addToLibraryButtonStyleSmall = const ButtonStyle(),
        genreSeparatorTextStyle = genreTextStyle.copyWith(
          color: genreTextStyle.color!.withOpacity(0.38),
        );

  factory BannerViewThemeData.from(BuildContext context) {
    final colors = context.theme.colorScheme;
    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)
            ? const EdgeInsets.all(20)
            : const EdgeInsets.all(18);
      }),
      iconSize: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)
            ? 30
            : 28;
      }),
      side: WidgetStateProperty.resolveWith((states) => BorderSide(
          color: states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)
              ? colors.primaryContainer
              : colors.onSurfaceVariant,
          width: 2)),
      iconColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)
            ? colors.onPrimaryContainer
            : colors.onSurfaceVariant;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)
            ? colors.primaryContainer
            : colors.surface.withOpacity(0.38);
      }),
    );

    final descriptionTextStyle = context.theme.textTheme.bodyLarge!;
    final descriptionTextStyleSmall = context.theme.textTheme.bodyMedium!;

    final gradientBaseColor = context.theme.colorScheme.surface;

    final (bottomGradient, sideGradient) = (
      gradientBaseColor,
      gradientBaseColor.withOpacity(0.8),
      gradientBaseColor.withOpacity(0.5),
      gradientBaseColor.withOpacity(0.2)
    ).let((it) {
      return (
        LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              it.$1,
              it.$1,
              it.$2,
              it.$2,
              it.$3,
              it.$3,
              it.$4,
              it.$4,
            ]),
        LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              it.$2,
              it.$3,
              it.$4,
            ])
      );
    });

    final genreTextStyle = context.theme.textTheme.bodyMedium!
        .copyWith(color: colors.onSurfaceVariant);
    final genreTextStyleSmall = context.theme.textTheme.bodySmall!
        .copyWith(color: colors.onSurfaceVariant);

    final titleTextStyle = context.theme.textTheme.headlineMedium!
        .copyWith(fontWeight: FontWeight.bold);
    final titleTextStyleSmall = context.theme.textTheme.headlineSmall!
        .copyWith(fontWeight: FontWeight.bold);

    const ratingIconSize = 24.0;
    final ratingIconColor = colors.primary;

    return BannerViewThemeData._(
      titleTextStyle: titleTextStyle,
      titleTextStyleSmall: titleTextStyleSmall,
      genreTextStyle: genreTextStyle,
      genreTextStyleSmall: genreTextStyleSmall,
      descriptionTextStyleSmall: descriptionTextStyleSmall,
      navigationButtonStyle: buttonStyle,
      descriptionTextStyle: descriptionTextStyle,
      gradientBaseColor: gradientBaseColor,
      bottomGradient: bottomGradient,
      sideGradient: sideGradient,
      ratingIconSize: ratingIconSize,
      ratingIconColor: ratingIconColor,
    );
  }
}
