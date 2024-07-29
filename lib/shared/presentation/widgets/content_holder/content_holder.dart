import 'dart:ui';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class ContentHolderThemeData {
  ContentHolderThemeData(BuildContext context) : _context = context;

  final BuildContext _context;

  late final ColorScheme _colorScheme = _context.theme.colorScheme;

  late final TextTheme _textTheme = _context.theme.textTheme;

  factory ContentHolderThemeData.forSize(
      BuildContext context, ScreenSize screenSize) {
    return screenSize.when(
      desktop: () => ContentHolderThemeDataDesktop(context),
      tablet: () => ContentHolderThemeDataTablet(context),
      mobile: () => ContentHolderThemeDataMobile(context),
    );
  }

  static const _holderBorderRadius = BorderRadius.all(Radius.circular(15));

  static const _numberBorderRadius =
      BorderRadius.only(bottomRight: Radius.circular(15));

  static const _playButtonContainerHeight = 55.0;

  BorderRadius get numberBorderRadius => _numberBorderRadius;

  BorderRadius get holderBorderRadius => _holderBorderRadius;

  BorderRadius get gridImageBorderRadius => const BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15));

  BorderRadius get listImageBorderRadius => _holderBorderRadius;

  abstract final double listImageWidth;

  abstract final double listImageHeight;

  double get playButtonContainerHeight => _playButtonContainerHeight;

  double get playButtonIconSize => MaterialTheme.iconSize;

  Color get playButtonBackgroundColor => Colors.black.withOpacity(0.7);

  double get playButtonSize => MaterialTheme.iconButtonSize;

  EdgeInsets get playButtonPadding => const EdgeInsets.all(4);

  Color get playButtonColor => Colors.white;

  Color get numberBackgroundColor => _colorScheme.onPrimaryContainer;

  TextStyle get numberTextStyle => _textTheme.titleMedium!.copyWith(
        color: _colorScheme.surface,
        fontWeight: FontWeight.bold,
      );

  TextStyle get fillerTextStyle => _textTheme.titleSmall!.copyWith(
        color: _colorScheme.surface,
        fontStyle: FontStyle.italic,
      );

  BorderRadius get fillerBorderRadius =>
      const BorderRadius.only(bottomLeft: Radius.circular(15));

  abstract final double gridImageHeight;

  abstract final TextStyle titleTextStyle;

  abstract final TextStyle descriptionTextStyle;

  int maxTitleLines = 3;

  final Color fillerColor = Color(0xff4f3a35);
}

class ContentHolderThemeDataDesktop extends ContentHolderThemeData {
  ContentHolderThemeDataDesktop(super.context);

  @override
  double get gridImageHeight => 150.0;

  @override
  TextStyle get titleTextStyle => _textTheme.titleMedium!;

  @override
  TextStyle get descriptionTextStyle => _textTheme.bodyMedium!;

  @override
  double get listImageWidth => 200.0;

  @override
  double get listImageHeight => 120;
}

class ContentHolderThemeDataMobile extends ContentHolderThemeData {
  ContentHolderThemeDataMobile(super.context);

  @override
  double get gridImageHeight => 100.0;

  @override
  TextStyle get titleTextStyle => _textTheme.titleSmall!;

  @override
  TextStyle get descriptionTextStyle => _textTheme.bodySmall!;

  @override
  int get maxTitleLines => 2;

  @override
  double get listImageWidth => 160.0;

  @override
  double get listImageHeight => 100;
}

class ContentHolderThemeDataTablet extends ContentHolderThemeDataMobile {
  ContentHolderThemeDataTablet(super.context);

  @override
  double get gridImageHeight => 120.0;

  @override
  int get maxTitleLines => 3;

  @override
  double get listImageWidth => 180.0;
}

class ContentHolderList extends StatelessWidget {
  final IMediaContent content;
  const ContentHolderList({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      final theme = ContentHolderThemeData.forSize(context, screenSize);
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
                      url: content.image,
                      fit: BoxFit.fill,
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
                    content.name ?? 'No Title',
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
  final IMediaContent content;

  const ContentHolderGrid({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      final theme = ContentHolderThemeData.forSize(context, screenSize);
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
                      url: content.image,
                      fit: BoxFit.fill,
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
                  content.name ?? 'No Title',
                  maxLines: theme.maxTitleLines,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleTextStyle,
                ),
              ),
            ],
          ),
        ),
      );

      // return Column(
      //   children: [
      //     const Spacer()
      //   ],
      // );
    });
  }
}  

// // class ContentHolderGrid extends StatelessWidget {
// //   const ContentHolderGrid({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       elevation: 3.0,
// //       borderRadius: ContentHolderThemeData._holderBorderRadius,
// //       child: InkWell(
// //         onTap: () {},
// //         child: ,
// //       ),
// //     );
// //   }
// // }

// class ContentHolder extends StatelessWidget {
//   final VoidCallback onTap;
//   final num number;
//   final String? title;
//   final String? image;
//   final String? description;
//   final double? rating;
//   final IconData? icon;
//   final String? label;
//   // final Progress? progress;
//   const ContentHolder({
//     super.key,
//     required this.onTap,
//     required this.number,
//     required this.title,
//     required this.image,
//     this.description,
//     this.rating,
//     this.icon,
//     this.label,
//     // this.progress,
//   });

//   ContentHolder.Episode({
//     super.key,
//     required this.onTap,
//     required IMediaContent episode,
//     required String? fallbackImage,
//     required int index,
//     // required this.progress,
//   })  : number = episode.number ?? index + 1,
//         title = episode.name ?? 'Episode ${episode.number ?? index + 1}',
//         image = episode.image ?? fallbackImage,
//         description = episode.description,
//         rating = null,
//         icon = Icons.play_arrow,
//         label = episode.isFiller != null && episode.isFiller! ? 'Filler' : null;

//   @override
//   Widget build(BuildContext context) {
//     final width = context.width;
//     final theme = context.theme;
//     final colors = theme.colorScheme;
//     final textTheme = theme.textTheme;
//     final screenSize = ScreenSize.getScreenSize(MediaQuery.of(context).size);
//     final isMobile = screenSize.isMobile;

//     final titleTextStyle =
//         (isMobile ? textTheme.titleSmall : textTheme.titleMedium)!
//             .copyWith(fontWeight: FontWeight.w600);

//     final onSurfaceWithOpacity = colors.onSurface.withOpacity(0.7);

//     final ratingTextStyle =
//         (isMobile ? textTheme.bodySmall : textTheme.bodyMedium)!
//             .copyWith(color: onSurfaceWithOpacity, fontWeight: FontWeight.w600);

//     final numberBackgroundColor = colors.onPrimaryContainer;

//     final numberTextStyle =
//         (isMobile ? textTheme.titleMedium : textTheme.titleLarge)!.copyWith(
//       color: colors.surface,
//       fontWeight: FontWeight.bold,
//     );

//     final posterHeight = isMobile ? 100.0 : 120.0;

//     final posterWidth = isMobile ? 170.0 : 200.0;

//     final icondata = icon ?? Icons.play_arrow;

//     final iconSize = isMobile ? 25.0 : 35.0;

//     final TextStyle? descriptionTextStyle;

//     if (description == null) {
//       descriptionTextStyle = null;
//     } else {
//       descriptionTextStyle = ratingTextStyle.copyWith(
//         fontWeight: FontWeight.normal,
//       );
//     }

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         child: SizedBox(
//           width: width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Row(
//               //   mainAxisSize: MainAxisSize.min,
//               //   crossAxisAlignment: CrossAxisAlignment.start,
//               //   mainAxisAlignment: MainAxisAlignment.start,
//               //   children: [
//               //    ,
//               //     // const HorizontalSpace(10),
//               //     // ,
//               //   ],
//               // ),
//               _right(
//                 posterHeight: posterHeight,
//                 posterWidth: posterWidth,
//                 icon: icondata,
//                 iconSize: iconSize,
//                 numberBackgroundColor: numberBackgroundColor,
//                 numberTextStyle: numberTextStyle,
//               ),
//               _left(
//                 title: title,
//                 rating: rating,
//                 titleTextStyle: titleTextStyle,
//                 ratingTextStyle: ratingTextStyle,
//               ),
//               if (description != null && description!.isNotEmpty) ...[
//                 _description(
//                     description: description!, style: descriptionTextStyle!),
//                 const VerticalSpace(10),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _left({
//     required String? title,
//     required double? rating,
//     required TextStyle titleTextStyle,
//     required TextStyle ratingTextStyle,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const VerticalSpace(5),
//         Text(
//           title ?? 'No Title',
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//           style: titleTextStyle,
//         ),
//         const VerticalSpace(5),
//         Text(
//           'Rated: ${rating ?? 0.0}',
//           style: ratingTextStyle,
//         )
//       ],
//     );
//   }

//   Widget _description({required String description, required TextStyle style}) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Align(
//         alignment: Alignment.topLeft,
//         child: ExpandableText(
//           description,
//           expandText: '',
//           maxLines: 3,
//           style: style,
//         ),
//       ),
//     );
//   }

//   Widget _right({
//     required double posterHeight,
//     required double posterWidth,
//     required IconData icon,
//     required double iconSize,
//     required Color numberBackgroundColor,
//     required TextStyle numberTextStyle,
//   }) {
//     return Flexible(
//       child: Stack(
//         fit: StackFit.passthrough,
//         alignment: Alignment.center,
//         children: [
//           ClipRRect(
//             borderRadius: ContentHolderThemeData._holderBorderRadius,
//             child: ImageHolder.network(
//               height: posterHeight,
//               width: posterWidth,
//               url: image,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             height: ContentHolderThemeData._playButtonContainerHeight,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white, width: 2),
//               color: Colors.black.withOpacity(0.7),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: iconSize,
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   borderRadius: ContentHolderThemeData._numberBorderRadius,
//                   color: numberBackgroundColor),
//               child: Text(
//                 number.toString(),
//                 style: numberTextStyle,
//               ),
//             ),
//           ),
//           // if (progress != null)
//           //   Positioned(
//           //     right: 0,
//           //     left: 0,
//           //     bottom: 0,
//           //     child: LinearProgressIndicator(
//           //       value: progress!.progress.inMilliseconds /
//           //           progress!.total.inMilliseconds,
//           //     ),
//           //   )
//         ],
//       ),
//     );
//   }
// }
