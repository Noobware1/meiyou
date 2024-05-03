// ignore_for_file: non_constant_identifier_names

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou_extensions_lib/models.dart';

class CardHolder extends StatelessWidget {
  final VoidCallback onTap;
  final num number;
  final String? title;
  final String? image;
  final String? description;
  final double? rating;
  final IconData? icon;
  final String? label;
  const CardHolder({
    super.key,
    required this.onTap,
    required this.number,
    required this.title,
    required this.image,
    this.description,
    this.rating,
    this.icon,
    this.label,
  });

  CardHolder.Episode({
    super.key,
    required this.onTap,
    required Episode episode,
    required String?  fallbackImage,
    required int index,
  })  : number = episode.number ?? index + 1,
        title = episode.name ?? 'Episode ${episode.number ?? index + 1}',
        image = episode.image ?? fallbackImage,
        description = episode.description,
        rating = null,
        icon = Icons.play_arrow,
        label = episode.isFiller != null && episode.isFiller! ? 'Filler' : null;

  CardHolder.Movie({
    super.key,
    required this.onTap,
    required this.title,
    required Movie movie,
    required String? fallbackImage,
  })  : number = 0,
        image = movie.image ?? fallbackImage,
        description = movie.description,
        rating = null,
        icon = Icons.play_arrow,
        label = null;

  static const boderRadius = BorderRadius.all(Radius.circular(15));

  static const titleDefault = 'No Title';

  static const ratingDefault = 0.0;

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final boderColor = context.theme.colorScheme.secondary.withOpacity(0.2);
    final backgroundColor = context.theme.colorScheme.surfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: boderRadius, side: BorderSide(color: boderColor)),
        color: backgroundColor,
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _right(),
                  const HorizontalSpace(10),
                  _left(),
                ],
              ),
              if (description != null && description!.isNotEmpty) ...[
                _Description(description: description!),
                const VerticalSpace(10),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _left() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpace(5),
          _Title(title: title ?? titleDefault),
          const VerticalSpace(5),
          _Rating(rating: rating ?? ratingDefault)
        ],
      ),
    );
  }

  Widget _right() {
    return Flexible(
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          _ImageHolder(image: image),
          _Icon(icon: icon),
          Positioned(
            top: 0,
            left: 0,
            child: _Number(number: number),
          ),
        ],
      ),
    );
  }
}

class _Number extends StatelessWidget {
  final num number;

  const _Number({super.key, required this.number});

  static const padding = EdgeInsets.all(8);

  static const boderRadius = BorderRadius.only(
      topLeft: Radius.circular(15), bottomRight: Radius.circular(15));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: boderRadius,
        color: context.theme.colorScheme.primary,
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: isMobile ? MobileFontSize.normal : DesktopFontSize.normal,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ImageHolder extends StatelessWidget {
  const _ImageHolder({
    super.key,
    required this.image,
  });

  final String? image;

  static const heightMobile = 100.0;

  static const heightDesktop = 120.0;

  static const widthMobile = 170.0;

  static const widthDesktop = 200.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ImageHolder(
        height: isMobile ? heightMobile : heightDesktop,
        width: isMobile ? widthMobile : widthDesktop,
        imageUrl: image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final IconData? icon;
  const _Icon({super.key, this.icon});

  static const playButtonSize = 55.0;

  static const iconSizeMobile = 25.0;

  static const iconSizeDesktop = 35.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: playButtonSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.black.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.play_arrow,
        color: Colors.white,
        size: isMobile ? iconSizeMobile : iconSizeDesktop,
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  final double rating;
  const _Rating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Rated: ${rating}',
      style: TextStyle(
          fontSize: isMobile ? MobileFontSize.small : DesktopFontSize.small,
          color: context.theme.colorScheme.onSurface.withOpacity(0.7),
          fontWeight: FontWeight.w600),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;

  const _Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topLeft,
        child: ExpandableText(
          description,
          expandText: '',
          maxLines: 3,
          style: TextStyle(
            fontSize: isMobile ? MobileFontSize.small : DesktopFontSize.small,
            color: context.theme.colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
