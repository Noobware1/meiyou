import 'package:flutter/material.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/image_holder.dart';

class ClickablePosterHolder extends StatelessWidget {
  final VoidCallback onTap;
  final PosterHolder holder;
  const ClickablePosterHolder({
    super.key,
    required this.onTap,
    required this.holder,
  });

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
          Positioned.fill(
            child: Material(
                type: MaterialType.button,
                color: Colors.transparent,
                borderRadius: borderRadius,
                animationDuration: _defaultDuration,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: onTap,
                )),
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

class PosterHolderWithContentItem extends PosterHolderWithTitle {
  final TextStyle infoTextStyle;
  final int? total;
  final int? current;

  PosterHolderWithContentItem({
    super.key,
    required super.height,
    required super.width,
    super.backgroundColor,
    super.borderRadius,
    super.fit,
    required ContentItem contentItem,
    required TextStyle titleTextStyle,
    required this.infoTextStyle,
  })  : total = contentItem.totalCount,
        current = contentItem.currentCount,
        super(
          imageUrl: contentItem.poster,
          title: contentItem.title,
          textStyle: titleTextStyle,
        );

  @override
  List<Widget> _buildColumnChildren(BuildContext context) {
    return super._buildColumnChildren(context)
      ..add(Align(
        alignment: Alignment.topRight,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: current == null || current! < 0 ? '~' : current!.toString(),
              style: infoTextStyle.copyWith(
                  color: context.theme.colorScheme.primary),
            ),
            TextSpan(
              text: ' | ',
              style: infoTextStyle.copyWith(
                  color: context.theme.colorScheme.secondary),
            ),
            TextSpan(
              text: total == null || total! < 0 ? '~' : total!.toString(),
              style: infoTextStyle.copyWith(
                color: context.theme.colorScheme.secondary,
              ),
            ),
          ]),
        ),
      ));
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
        children: _buildColumnChildren(context),
      ),
    );
  }

  List<Widget> _buildColumnChildren(BuildContext context) {
    return [
      super.build(context),
      const SizedBox(
        height: 5,
      ),
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
