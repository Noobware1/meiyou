// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/diagnostics.dart';
// import 'package:flutter/src/services/system_chrome.dart';

// class CustomAppBar extends StatefulWidget implements AppBar {
//   CustomAppBar({
//     this.key,
//     this.leading,
//     this.automaticallyImplyLeading = true,
//     this.title,
//     this.actions,
//     this.flexibleSpace,
//     this.bottom,
//     this.elevation,
//     this.scrolledUnderElevation,
//     this.notificationPredicate = defaultScrollNotificationPredicate,
//     this.shadowColor,
//     this.surfaceTintColor,
//     this.shape,
//     this.backgroundColor,
//     this.foregroundColor,
//     this.iconTheme,
//     this.actionsIconTheme,
//     this.primary = true,
//     this.centerTitle,
//     this.excludeHeaderSemantics = false,
//     this.titleSpacing,
//     this.toolbarOpacity = 1.0,
//     this.bottomOpacity = 1.0,
//     this.toolbarHeight,
//     this.leadingWidth,
//     this.toolbarTextStyle,
//     this.titleTextStyle,
//     this.systemOverlayStyle,
//     this.forceMaterialTransparency = false,
//     this.clipBehavior,
//   })  : preferredSize =
//             _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),
//         super(key: key);

//   @override
//   final List<Widget>? actions;

//   @override
//   final IconThemeData? actionsIconTheme;

//   @override
//   final bool automaticallyImplyLeading;

//   @override
//   final Color? backgroundColor;

//   @override
//   final PreferredSizeWidget? bottom;

//   @override
//   final double bottomOpacity;

//   @override
//   final bool? centerTitle;

//   @override
//   final Clip? clipBehavior;

//   @override
//   final double? elevation;

//   @override
//   final bool excludeHeaderSemantics;

//   @override
//   final Widget? flexibleSpace;

//   @override
//   final bool forceMaterialTransparency;

//   @override
//   final Color? foregroundColor;

//   @override
//   final IconThemeData? iconTheme;

//   @override
//   final Key? key;

//   @override
//   final Widget? leading;

//   @override
//   final double? leadingWidth;

//   @override
//   final ScrollNotificationPredicate notificationPredicate;

//   @override
//   final Size preferredSize;

//   @override
//   final bool primary;

//   @override
//   final double? scrolledUnderElevation;

//   @override
//   final Color? shadowColor;

//   @override
//   final ShapeBorder? shape;

//   @override
//   final Color? surfaceTintColor;

//   @override
//   final SystemUiOverlayStyle? systemOverlayStyle;

//   @override
//   final Widget? title;

//   @override
//   final double? titleSpacing;

//   @override
//   final TextStyle? titleTextStyle;

//   @override
//   final double? toolbarHeight;

//   @override
//   final double toolbarOpacity;

//   @override
//   final TextStyle? toolbarTextStyle;

//   @override
//   State<AppBar> createState() {
//     throw UnimplementedError();
//   }
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

// class _PreferredAppBarSize extends Size {
//   _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
//       : super.fromHeight(
//             (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

//   final double? toolbarHeight;
//   final double? bottomHeight;
// }
