// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:meiyou/a.dart';
// import 'package:meiyou/core/utils/extensions/context.dart';
// import 'package:meiyou/details.dart';
// import 'package:meiyou/shared/domain/models/media.dart';
// import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
// import 'package:meiyou/shared/presentation/widgets/spacing.dart';
// import 'package:meiyou_extensions_lib/models.dart';
// import 'package:nice_dart/nice_dart.dart';

// class InfoPageDesktop extends StatelessWidget {
//   const InfoPageDesktop({super.key});

//   static const defaultPadding = EdgeInsets.only(left: 100, right: 100);

//   @override
//   Widget build(BuildContext context) {
//     final data = getDetails();
//     return Builder(builder: (context) {
//       return SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 DecoratedBox(
//                   position: DecorationPosition.foreground,
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                         strokeAlign: -0.050,
//                         color: context.theme.scaffoldBackgroundColor,
//                       ),
//                       gradient: [
//                         context.theme.colorScheme.surface,
//                         context.theme.colorScheme.surface.withOpacity(0.8),
//                         context.theme.colorScheme.surface.withOpacity(0.5),
//                         context.theme.colorScheme.surface.withOpacity(0.2),
//                       ].let((it) => LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: [
//                                 it[0],
//                                 it[0],
//                                 it[1],
//                                 it[1],
//                                 it[2],
//                                 it[2],
//                                 it[3],
//                                 it[3],
//                               ]))),
//                   child: ImageHolder.network(
//                     width: context.width,
//                     url: data.bannerOrPoster,
//                     fit: BoxFit.cover,
//                     height: 350,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: defaultPadding.left,
//                       top: 280,
//                       bottom: defaultPadding.bottom,
//                       right: defaultPadding.right),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(children: [
//                         ImageHolder.network(
//                             url: data.poster, height: 280, width: 200),
//                         const VerticalSpace(20),
//                         FilledButton.icon(
//                           style: ButtonStyle(
//                             fixedSize: WidgetStatePropertyAll(Size(200, 40)),
//                             shape: WidgetStatePropertyAll(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                           onPressed: () {},
//                           label: const Text('Add To List',
//                               style: TextStyle(
//                                 fontSize: 17,
//                               )),
//                           icon: const Icon(Icons.add),
//                         ),
//                       ]),
//                       const HorizontalSpace(30),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 80),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 data.title.trim(),
//                                 textAlign: TextAlign.left,
//                                 style: const TextStyle(
//                                     fontSize: 30, fontWeight: FontWeight.w600),
//                               ),
//                               if (data.otherTitles.isNotEmptyOrNull)
//                                 _buildOtherTitles(data.otherTitles!),
//                               const VerticalSpace(20),
//                               if (data.genres.isNotEmptyOrNull)
//                                 _buildGenres(data.genres!),
//                               if (data.description != null) ...[
//                                 const VerticalSpace(20),
//                                 ExpandableText(
//                                   text: data.description!,
//                                   maxLines: 5,
//                                   style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w400),
//                                   animation: true,

//                                   // showButtons: true,
//                                 )
//                               ],
//                               const VerticalSpace(10),
//                               _OtherInfo(mediaDetails: data),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildGenres(List<String> genres) {
//     return Wrap(
//       // alignment: WrapAlignment.center,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       // runSpacing: 10,
//       spacing: 10,
//       children: genres
//           .mapIndexed((index, genre) => [
//                 Text(
//                   genre,
//                   style: const TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 if (index != genres.length - 1)
//                   Container(
//                     height: 5,
//                     width: 5,
//                     decoration: const BoxDecoration(
//                         shape: BoxShape.circle, color: Colors.grey),
//                   ),
//               ])
//           .reduce((a, b) => [...a, ...b]),
//     );
//   }

//   Widget _buildOtherTitles(List<String> otherTitles) {
//     return Wrap(
//         crossAxisAlignment: WrapCrossAlignment.center,
//         spacing: 10,
//         children: otherTitles.mapListIndexed((index, title) {
//           return Padding(
//             padding: const EdgeInsets.only(right: 10, top: 10),
//             child: Text(
//               (index == otherTitles.length - 1) ? title : '$title,',
//               style: const TextStyle(
//                   fontSize: 15,
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.w400),
//             ),
//           );
//         }));
//   }
// }

// class _OtherInfo extends StatelessWidget {
//   final Media mediaDetails;
//   const _OtherInfo({required this.mediaDetails});

//   static const _titleTextStyle =
//       TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w700);

//   static const _itemTextStyle =
//       TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w500);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       bool isSmall = constraints.maxWidth < 800;
//       double defaultPadding = 50.0;
//       double adjustedPadding = 20.0;

//       return Wrap(
//         runSpacing: 10,
//         children: [
//           _build(
//               space: isSmall ? adjustedPadding : defaultPadding,
//               title: 'Mean Score',
//               item: mediaDetails.score?.toString() ?? '~'),
//           _build(
//               space: isSmall ? adjustedPadding : defaultPadding,
//               title: 'Status',
//               item: mediaDetails.status.name.captialize()),
//           _build(
//               space: isSmall ? adjustedPadding : defaultPadding,
//               title: 'Format',
//               item: mediaDetails.format.name.captialize()),
//         ],
//       );
//     });
//   }

//   Widget _build(
//       {required String title, required String item, required double space}) {
//     return Padding(
//       padding: EdgeInsets.only(right: space),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: _titleTextStyle,
//           ),
//           const VerticalSpace(5),
//           Text(
//             item,
//             style: _itemTextStyle,
//           ),
//         ],
//       ),
//     );
//   }
// }
