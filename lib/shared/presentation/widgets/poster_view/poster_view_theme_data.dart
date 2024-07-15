import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/size_constants.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';

class PosterViewThemeData {
  final TextStyle labelTextStyleSmall;

  final TextStyle labelTextStyle;

  final TextStyle titleTextStyleSmall;

  final TextStyle titleTextStyle;

  final double spacing;

  final Size posterSizeSmall;

  final BorderRadius borderRadius;

  final Size posterSize;

  final EdgeInsets contentPadding;

  final double labelBoxHeight;

  final double titleSpacing;

  final EdgeInsets titlePadding;

  final double sizeIncreaseValue;

  PosterViewThemeData({
    required this.labelTextStyle,
    required this.labelTextStyleSmall,
    required this.titleTextStyle,
    required this.titleTextStyleSmall,
    this.posterSize = const Size(defaultPosterWidthBig, defaultPosterHeightBig),
    this.posterSizeSmall =
        const Size(defaultPosterWidthSmall, defaultPosterHeightSmall),
    this.spacing = 10.0,
    this.contentPadding = const EdgeInsets.only(left: 10),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.labelBoxHeight = 52.0,
    this.titleSpacing = 6.0,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10.0),
    this.sizeIncreaseValue = 20.0,
  });

  factory PosterViewThemeData.getDefault(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PosterViewThemeData(
      labelTextStyle:
          textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
      labelTextStyleSmall:
          textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      titleTextStyle: textTheme.bodyMedium!,
      titleTextStyleSmall: textTheme.bodySmall!,
    );
  }

  TextStyle getLabelTextStyleForSize(ScreenSize screenSize) {
    return screenSize.isDesktop ? labelTextStyle : labelTextStyleSmall;
  }

  TextStyle getTitleTextStyleForSize(ScreenSize screenSize) {
    return screenSize.isDesktop ? titleTextStyle : titleTextStyleSmall;
  }

  Size getPosterSizeForSize(ScreenSize screenSize) {
    return screenSize.isDesktop ? posterSize : posterSizeSmall;
  }

  PosterViewThemeData copyWith({
    TextStyle? labelTextStyle,
    TextStyle? labelTextStyleSmall,
    TextStyle? titleTextStyle,
    TextStyle? titleTextStyleSmall,
    double? spacing,
    Size? posterSizeSmall,
    Size? posterSize,
    EdgeInsets? contentPadding,
  }) {
    return PosterViewThemeData(
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      labelTextStyleSmall: labelTextStyleSmall ?? this.labelTextStyleSmall,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      titleTextStyleSmall: titleTextStyleSmall ?? this.titleTextStyleSmall,
      posterSize: posterSize ?? this.posterSize,
      posterSizeSmall: posterSizeSmall ?? this.posterSizeSmall,
      spacing: spacing ?? this.spacing,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }
}
