import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar.dart';

class CustomNavigationBarTheme extends InheritedTheme {
  final CustomNavigationBarThemeData data;
  CustomNavigationBarTheme({required this.data, required super.child});

  @override
  bool updateShouldNotify(covariant CustomNavigationBarTheme oldWidget) => true;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final theme = context.theme;
    final data = CustomNavigationBarTheme.of(context);
    return CustomNavigationBarTheme(data: data, child: child);
  }

  static CustomNavigationBarThemeData of(BuildContext context) {
    final customNavigationBarTheme =
        context.dependOnInheritedWidgetOfExactType<CustomNavigationBarTheme>();
    return customNavigationBarTheme?.data ??
        CustomNavigationBarThemeData.material3(context);
  }
}

class CustomNavigationBarThemeData with Diagnosticable {
  CustomNavigationBarThemeData({
    required this.height,
    required this.backgroundColor,
    required this.elevation,
    required this.shadowColor,
    required this.surfaceTintColor,
    required this.indicatorColor,
    required this.indicatorShape,
    required this.selectedLabelTextStyle,
    required this.unselectedLabelTextStyle,
    required this.selectedIconTheme,
    required this.unselectedIconTheme,
    required this.labelBehavior,
    required this.minWidth,
  });

  /// Overrides the default value of [NavigationBar.height].
  final double height;

  /// Overrides the default value of [NavigationBar.backgroundColor].
  final Color backgroundColor;

  /// Overrides the default value of [NavigationBar.elevation].
  final double elevation;

  /// Overrides the default value of [NavigationBar.shadowColor].
  final Color shadowColor;

  /// Overrides the default value of [NavigationBar.surfaceTintColor].
  final Color surfaceTintColor;

  /// Overrides the default value of [NavigationBar]'s selection indicator.
  final Color indicatorColor;

  /// Overrides the default shape of the [NavigationBar]'s selection indicator.
  final ShapeBorder indicatorShape;

  /// The style to merge with the default text style for
  /// [NavigationDestination] labels.
  ///
  /// You can use this to specify a different style when the label is selected.
  final TextStyle selectedLabelTextStyle;

  final TextStyle unselectedLabelTextStyle;

  /// The theme to merge with the default icon theme for
  /// [NavigationDestination] icons.
  ///
  /// You can use this to specify a different icon theme when the icon is
  /// selected.
  final IconThemeData selectedIconTheme;

  final IconThemeData unselectedIconTheme;

  final double minWidth;

  /// Overrides the default value of [NavigationBar.labelBehavior].
  final DestinationLabelBehavior labelBehavior;

  static CustomNavigationBarThemeData material3(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final backgroundColor = colors.surfaceContainer;

    final selectedIconTheme = IconThemeData(
      size: 24.0,
      color: colors.onSecondaryContainer,
    );

    final unselectedIconTheme = IconThemeData(
      size: 24.0,
      color: colors.onSurfaceVariant,
    );

    final selectedLabelTextStyle = textTheme.labelMedium!.apply(
      color: colors.onSecondaryContainer,
    );

    final unselectedLabelTextStyle = textTheme.labelMedium!.apply(
      color: colors.onSurfaceVariant,
    );

    final indicatorColor = colors.secondaryContainer;

    const height = 80.0;

    const elevation = 3.0;

    const labelBehavior = DestinationLabelBehavior.alwaysShow;

    const indicatorShape = StadiumBorder();

    const shadowColor = Colors.transparent;

    const surfaceTintColor = Colors.transparent;

    return CustomNavigationBarThemeData(
      height: height,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      indicatorColor: indicatorColor,
      indicatorShape: indicatorShape,
      selectedLabelTextStyle: selectedLabelTextStyle,
      unselectedLabelTextStyle: unselectedLabelTextStyle,
      selectedIconTheme: selectedIconTheme,
      unselectedIconTheme: unselectedIconTheme,
      labelBehavior: labelBehavior,
      minWidth: 72.0,
    );
  }

  @override
  int get hashCode => Object.hash(
        height,
        backgroundColor,
        elevation,
        shadowColor,
        surfaceTintColor,
        indicatorColor,
        indicatorShape,
        selectedLabelTextStyle,
        unselectedLabelTextStyle,
        selectedIconTheme,
        unselectedIconTheme,
        labelBehavior,
        // overlayColor,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomNavigationBarThemeData &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.indicatorColor == indicatorColor &&
        other.indicatorShape == indicatorShape &&
        other.selectedIconTheme == selectedIconTheme &&
        other.unselectedIconTheme == unselectedIconTheme &&
        other.selectedLabelTextStyle == selectedLabelTextStyle &&
        other.unselectedLabelTextStyle == unselectedLabelTextStyle &&
        other.labelBehavior == labelBehavior; // &&
    // other.overlayColor == overlayColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height, defaultValue: null));
    properties.add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties
        .add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor,
        defaultValue: null));
    properties.add(
        ColorProperty('indicatorColor', indicatorColor, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>(
        'indicatorShape', indicatorShape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'selectedLabelTextStyle', selectedLabelTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'unselectedLabelTextStyle', unselectedLabelTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<IconThemeData>(
        'selectedIconTheme', selectedIconTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<IconThemeData>(
        'unselectedIconTheme', unselectedIconTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<DestinationLabelBehavior>(
        'labelBehavior', labelBehavior,
        defaultValue: null));
  }
}
