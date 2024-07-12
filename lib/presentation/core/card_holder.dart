// ignore_for_file: non_constant_identifier_names

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou_extensions_lib/models.dart';

const _titleTextDefault = 'No Title';

const _ratingDefault = 0.0;

const _numberBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(15), bottomRight: Radius.circular(15));

const _playButtonContainerHeight = 55.0;

const _holderBorderRadius = BorderRadius.all(Radius.circular(15));

class CardHolder extends StatelessWidget {
  final VoidCallback onTap;
  final num number;
  final String? title;
  final String? image;
  final String? description;
  final double? rating;
  final IconData? icon;
  final String? label;
  final Progress? progress;
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
    this.progress,
  });

  CardHolder.Episode({
    super.key,
    required this.onTap,
    required Episode episode,
    required String? fallbackImage,
    required int index,
    required this.progress,
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
    required this.progress,
  })  : number = 0,
        image = movie.image ?? fallbackImage,
        description = movie.description,
        rating = null,
        icon = Icons.play_arrow,
        label = null;

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final theme = context.theme;
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenSize = ScreenSize.fromWidth(width);
    final isMobile = screenSize.isMobile;
    final backgroundColor = colors.surface;

    final titleTextStyle =
        (isMobile ? textTheme.titleMedium : textTheme.titleLarge)!
            .copyWith(fontWeight: FontWeight.w600);

    final onSurfaceWithOpacity = colors.onSurface.withOpacity(0.7);

    final ratingTextStyle =
        (isMobile ? textTheme.bodySmall : textTheme.bodyMedium)!
            .copyWith(color: onSurfaceWithOpacity, fontWeight: FontWeight.w600);

    final numberBackgroundColor = colors.onSurface;

    final numberTextStyle =
        (isMobile ? textTheme.titleMedium : textTheme.titleLarge)!.copyWith(
      color: colors.surface,
      fontWeight: FontWeight.bold,
    );

    final posterHeight = isMobile ? 100.0 : 120.0;

    final posterWidth = isMobile ? 170.0 : 200.0;

    final icondata = icon ?? Icons.play_arrow;

    final iconSize = isMobile ? 25.0 : 35.0;

    final TextStyle? descriptionTextStyle;

    if (description == null) {
      descriptionTextStyle = null;
    } else {
      descriptionTextStyle = ratingTextStyle.copyWith(
        fontWeight: FontWeight.normal,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: _holderBorderRadius,

          // side: BorderSide(color: boderColor),
        ),
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
                  _right(
                    posterHeight: posterHeight,
                    posterWidth: posterWidth,
                    icon: icondata,
                    iconSize: iconSize,
                    numberBackgroundColor: numberBackgroundColor,
                    numberTextStyle: numberTextStyle,
                  ),
                  const HorizontalSpace(10),
                  _left(
                    title: title,
                    rating: rating,
                    titleTextStyle: titleTextStyle,
                    ratingTextStyle: ratingTextStyle,
                  ),
                ],
              ),
              if (description != null && description!.isNotEmpty) ...[
                _description(
                    description: description!, style: descriptionTextStyle!),
                const VerticalSpace(10),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _left({
    required String? title,
    required double? rating,
    required TextStyle titleTextStyle,
    required TextStyle ratingTextStyle,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpace(5),
          Text(
            title ?? _titleTextDefault,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: titleTextStyle,
          ),
          const VerticalSpace(5),
          Text(
            'Rated: ${rating ?? _ratingDefault}',
            style: ratingTextStyle,
          )
        ],
      ),
    );
  }

  Widget _description({required String description, required TextStyle style}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topLeft,
        child: ExpandableText(
          description,
          expandText: '',
          maxLines: 3,
          style: style,
        ),
      ),
    );
  }

  Widget _right({
    required double posterHeight,
    required double posterWidth,
    required IconData icon,
    required double iconSize,
    required Color numberBackgroundColor,
    required TextStyle numberTextStyle,
  }) {
    return Flexible(
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: _holderBorderRadius,
            child: ImageHolder(
              height: posterHeight,
              width: posterWidth,
              imageUrl: image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: _playButtonContainerHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: _numberBorderRadius,
                  color: numberBackgroundColor),
              child: Text(
                number.toString(),
                style: numberTextStyle,
              ),
            ),
          ),
          if (progress != null)
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: LinearProgressIndicator(
                value: progress!.progress.inMilliseconds /
                    progress!.total.inMilliseconds,
              ),
            )
        ],
      ),
    );
  }
}
