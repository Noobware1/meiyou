// import 'package:meiyou/shared/domain/models/extension_category.dart';
// import 'package:meiyou_extensions_lib/models.dart';
// import 'package:nice_dart/nice_dart.dart';

// class SavedMediaDetails extends MediaDetails {
//   const SavedMediaDetails({
//     required this.sourceId,
//     required this.category,
//     super.format,
//     super.title,
//     super.url,
//     super.otherTitles,
//     super.status,
//     super.banner,
//     super.poster,
//     super.score,
//     super.contentRating,
//     super.description,
//     super.startDate,
//     super.duration,
//     super.genres,
//     super.recommendations,
//     super.characters,
//     super.content,
//   });

//   final int sourceId;
//   final ExtensionCategory category;

//   static SavedMediaDetailsBuilder builder() {
//     return SavedMediaDetailsBuilder();
//   }

//   @override
//   SavedMediaDetailsBuilder newBuilder() => SavedMediaDetailsBuilder(this);
// }

// extension on String {
//   String getUrlWithoutDomain(String orig) {
//     try {
//       final uri = Uri.parse(orig);
//       var out = uri.path;
//       if (uri.query.isNotEmpty) {
//         out += "?${uri.query}";
//       }
//       if (uri.fragment.isNotEmpty) {
//         out += "#${uri.fragment}";
//       }
//       return out;
//     } catch (_) {
//       return orig;
//     }
//   }
// }

// final class SavedMediaDetailsBuilder extends MediaDetailsBuilder {
//   int? _sourceId;
//   ExtensionCategory? _category;

//   SavedMediaDetailsBuilder([SavedMediaDetails? super.mediaDetails])
//       : _sourceId = mediaDetails?.sourceId,
//         _category = mediaDetails?.category;

//   SavedMediaDetailsBuilder sourceId(int sourceId) => apply((_) {
//         _sourceId = sourceId;
//       });

//   SavedMediaDetailsBuilder category(ExtensionCategory category) => apply((_) {
//         _category = category;
//       });

//   @override
//   SavedMediaDetails build() {
//     assert(_sourceId != null, 'Source ID must not be null');
//     assert(_category != null, 'Category must not be null');
//     final details = super.build();
//     return SavedMediaDetails(
//       sourceId: _sourceId!,
//       category: _category!,
//       format: details.format,
//       title: details.title,
//       url: details.url,
//       otherTitles: details.otherTitles,
//       status: details.status,
//       banner: details.banner,
//       poster: details.poster,
//       score: details.score,
//       contentRating: details.contentRating,
//       description: details.description,
//       startDate: details.startDate,
//       duration: details.duration,
//       genres: details.genres,
//       recommendations: details.recommendations,
//       characters: details.characters,
//       content: details.content,
//     );
//   }
// }
