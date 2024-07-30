import 'dart:ui';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/helper/media_content_helper.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder_theme.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ContentHolderList extends StatelessWidget {
  final MediaContent content;
  final String? fallackImage;
  final String Function(MediaContent) getDefaultNameCallback;
  const ContentHolderList({
    super.key,
    required this.content,
    this.fallackImage,
    required this.getDefaultNameCallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ContentHolderTheme.of(context);
    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      return Card(
        clipBehavior: Clip.hardEdge,
        color: content.isFiller == true ? theme.fillerColor : null,
        // borderRadius: ContentHolderThemeData._holderBorderRadius,
        child: InkWell(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: theme.listImageBorderRadius,
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageHolder.network(
                      height: theme.listImageHeight,
                      width: theme.listImageWidth,
                      url: content.image ?? fallackImage,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: theme.numberBorderRadius,
                            color: theme.numberBackgroundColor),
                        child: Text(
                          content.number.toString(),
                          style: theme.numberTextStyle,
                        ),
                      ),
                    ),
                    if (content.isFiller == true)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: theme.fillerBorderRadius,
                              color: theme.numberBackgroundColor),
                          child: Text(
                            'Filler',
                            style: theme.fillerTextStyle,
                          ),
                        ),
                      ),
                    Container(
                      height: MaterialTheme.iconButtonSize,
                      padding: theme.playButtonPadding,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: theme.playButtonColor, width: 2),
                        color: theme.playButtonBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: theme.playButtonColor,
                        size: MaterialTheme.iconSize,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    content.name ?? getDefaultNameCallback(content),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ContentHolderGrid extends StatelessWidget {
  final MediaContent content;
  final String? fallackImage;
  final String Function(MediaContent) getDefaultNameCallback;
  const ContentHolderGrid({
    super.key,
    required this.content,
    this.fallackImage,
    required this.getDefaultNameCallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ContentHolderTheme.of(context);

    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      return Card(
        clipBehavior: Clip.hardEdge,
        color: content.isFiller == true ? theme.fillerColor : null,
        // borderRadius: ContentHolderThemeData._holderBorderRadius,
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: theme.gridImageBorderRadius,
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageHolder.network(
                      height: theme.gridImageHeight,
                      width: constraints.maxWidth,
                      url: content.image ?? fallackImage,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: theme.numberBorderRadius,
                            color: theme.numberBackgroundColor),
                        child: Text(
                          content.number.toString(),
                          style: theme.numberTextStyle,
                        ),
                      ),
                    ),
                    if (content.isFiller == true)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: theme.fillerBorderRadius,
                              color: theme.numberBackgroundColor),
                          child: Text(
                            'Filler',
                            style: theme.fillerTextStyle,
                          ),
                        ),
                      ),
                    Container(
                      height: MaterialTheme.iconButtonSize,
                      padding: theme.playButtonPadding,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: theme.playButtonColor, width: 2),
                        color: theme.playButtonBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: theme.playButtonColor,
                        size: MaterialTheme.iconSize,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  content.name ?? getDefaultNameCallback(content),
                  maxLines: theme.maxTitleLines,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleTextStyle,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
