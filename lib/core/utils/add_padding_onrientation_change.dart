import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

//only for mobile
EdgeInsets addPaddingOnOrientation(BuildContext context,
    {EdgeInsets? defaultPadding, EdgeInsets? paddingOnChanged}) {
  if (context.orientation == Orientation.landscape) {
    return paddingOnChanged ?? const EdgeInsets.only(left: 50, right: 50);
  }
  return defaultPadding ?? const EdgeInsets.only(left: 30, right: 30);
}
