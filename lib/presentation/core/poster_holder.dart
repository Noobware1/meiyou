import 'package:flutter/material.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/image_holder.dart';

class ClickablePosterHolder extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final PosterHolder holder;
  const ClickablePosterHolder(
      {super.key,
      required this.onTap,
      required this.holder,
      required this.onLongPress});

  static const _defaultDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        holder.borderRadius ?? PosterHolder._defaultBorderRadius;

    return SizedBox(
      height: holder.height,
      width: holder.width,
      child: Stack(
        children: [
          holder,
          Material(
            type: MaterialType.button,
            color: Colors.transparent,
            borderRadius: borderRadius,
            animationDuration: _defaultDuration,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
              onLongPress: onLongPress,
            ),
          ),
        ],
      ),
    );
  }
}

class PosterHolder extends ImageHolder {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  static const titleTextStyleMobile = TextStyle(
    fontSize: MobileFontSize.normal,
    fontWeight: FontWeight.w600,
  );

  static const titleTextStyleDesktop = TextStyle(
    fontSize: DesktopFontSize.normal,
    fontWeight: FontWeight.w600,
  );

  static const infoTextStyleMobile = TextStyle(
    fontSize: MobileFontSize.normal,
    fontWeight: FontWeight.w600,
  );

  static const infoTextStyleDesktop = TextStyle(
    fontSize: DesktopFontSize.small,
    fontWeight: FontWeight.w600,
  );

  static const _defaultBorderRadius = BorderRadius.all(Radius.circular(10));

  const PosterHolder({
    super.key,
    required super.height,
    required super.width,
    this.borderRadius,
    super.imageUrl,
    this.backgroundColor,
    super.fit,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? _defaultBorderRadius;
    return Container(
      decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: borderRadius),
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ImageHolder(
          height: height,
          width: width,
          fit: fit,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

class PosterHolderWithTitle extends PosterHolder {
  final String title;
  final TextStyle textStyle;

  const PosterHolderWithTitle({
    super.key,
    super.imageUrl,
    required this.title,
    required super.height,
    required super.width,
    super.backgroundColor,
    super.borderRadius,
    super.fit,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildColumnChildren(context),
      ),
    );
  }

  List<Widget> _buildColumnChildren(BuildContext context) {
    return [
      super.build(context),
      const VerticalSpace(5),
      SizedBox(
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: textStyle.copyWith(overflow: TextOverflow.ellipsis),
            maxLines: 2,
          ),
        ),
      ),
    ];
  }
}
