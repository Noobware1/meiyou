// import 'dart:convert';

// import 'package:isar/isar.dart';
// import 'package:nice_dart/nice_dart.dart';

// abstract mixin class ContentProgressMixin {
//   abstract final String? contentProgressEncoded;

//   @ignore
//   ContentProgress? get contentProgress {
//     try {
//       return contentProgressEncoded?.let((it) => ContentProgress.decode(it));
//     } catch (_) {
//       return null;
//     }
//   }
// }

// extension ContentInfoExtensions on ContentProgress {
//   R cast<R extends ContentProgress>() => this as R;

//   String encode() => jsonEncode(toJson());

//   R when<R>({
//     required R Function(MovieProgress) movie,
//     required R Function(SeriesProgress) series,
//     required R Function(AnimeProgress) anime,
//   }) {
//     if (this is MovieProgress) {
//       return movie(this as MovieProgress);
//     } else if (this is SeriesProgress) {
//       return series(this as SeriesProgress);
//     } else if (this is AnimeProgress) {
//       return anime(this as AnimeProgress);
//     } else {
//       throw 'Invalid type';
//     }
//   }
// }

// abstract interface class ContentProgress {
//   factory ContentProgress.decode(String encoded) =>
//       ContentProgress.fromJson(jsonDecode(encoded));

//   factory ContentProgress.fromJson(Map<String, dynamic> json) {
//     final type = json['type'] as int;
//     switch (type) {
//       case MovieProgress.type:
//         return MovieProgress.fromJson(json);
//       case SeriesProgress.type:
//         return SeriesProgress.fromJson(json);
//       case AnimeProgress.type:
//         return AnimeProgress.fromJson(json);
//       default:
//         throw 'Invalid type';
//     }
//   }
//   Map<String, dynamic> toJson();
// }

// class Progress {
//   final Duration progress;
//   final Duration total;

//   Progress({
//     required this.progress,
//     required this.total,
//   });

//   factory Progress.fromJson(Map<String, dynamic> json) {
//     return Progress(
//       progress: Duration(milliseconds: json['progress']),
//       total: Duration(milliseconds: json['total']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'progress': progress.inMilliseconds,
//       'total': total.inMilliseconds,
//     };
//   }
// }

// class EpisodeProgress {
//   final num? episode;
//   final Progress progress;

//   EpisodeProgress({
//     required this.episode,
//     required this.progress,
//   });

//   factory EpisodeProgress.fromJson(Map<String, dynamic> json) {
//     return EpisodeProgress(
//       episode: json['episode'],
//       progress: Progress.fromJson(json['progress']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'episode': episode,
//       'progress': progress.toJson(),
//     };
//   }
// }

// class SeasonProgress {
//   final num? season;
//   final int episodeListIndex;
//   final Map<int, EpisodeProgress> episodeProgresses;

//   SeasonProgress({
//     required this.season,
//     required this.episodeListIndex,
//     required this.episodeProgresses,
//   });

//   factory SeasonProgress.fromJson(Map<String, dynamic> json) {
//     return SeasonProgress(
//       season: json['season'],
//       episodeListIndex: json['ep_index'],
//       episodeProgresses: (json['progresses'] as Map)
//           .map((key, value) => MapEntry(key, EpisodeProgress.fromJson(value))),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'season': season,
//       'list_index': episodeListIndex,
//       'progresses':
//           episodeProgresses.map((key, value) => MapEntry(key, value.toJson())),
//     };
//   }
// }

// class MovieProgress extends Progress implements ContentProgress {
//   MovieProgress({required super.progress, required super.total});

//   static const type = 0;

//   factory MovieProgress.fromJson(Map<String, dynamic> json) {
//     return Progress.fromJson(json).let(
//       (it) => MovieProgress(
//         progress: it.progress,
//         total: it.total,
//       ),
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'progress': progress.inMilliseconds,
//       'total': total.inMilliseconds,
//     };
//   }
// }

// class SeriesProgress implements ContentProgress {
//   SeriesProgress({
//     required this.lastSeenSeason,
//     required this.lastSeenEpisode,
//     required this.progress,
//   });

//   static const type = 1;

//   final Map<int, SeasonProgress> progress;

//   final int lastSeenSeason;
//   final int lastSeenEpisode;

//   factory SeriesProgress.fromJson(Map<String, dynamic> json) {
//     return SeriesProgress(
//       lastSeenSeason: json['season'],
//       lastSeenEpisode: json['episode'],
//       progress: (json['progress'] as Map).map((key, value) =>
//           MapEntry(int.parse(key), SeasonProgress.fromJson(value))),
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'season': lastSeenSeason,
//       'episode': lastSeenEpisode,
//       'progress': progress
//           .map((key, value) => MapEntry(key.toString(), value.toJson())),
//     };
//   }

//   SeriesProgress copyWith({
//     int? lastSeenSeason,
//     int? lastSeenEpisode,
//     Map<int, SeasonProgress>? progress,
//   }) {
//     return SeriesProgress(
//       lastSeenSeason: lastSeenSeason ?? this.lastSeenSeason,
//       lastSeenEpisode: lastSeenEpisode ?? this.lastSeenEpisode,
//       progress: progress ?? this.progress,
//     );
//   }
// }

// class AnimeProgress implements ContentProgress {
//   AnimeProgress({
//     required this.lastSeen,
//     required this.episodeListIndex,
//     required this.progress,
//   });
//   static const type = 2;

//   final int episodeListIndex;
//   final int lastSeen;
//   final Map<int, EpisodeProgress> progress;

//   factory AnimeProgress.fromJson(Map<String, dynamic> json) {
//     return AnimeProgress(
//       lastSeen: json['lastSeen'],
//       episodeListIndex: json['ep_index'],
//       progress: (json['progress'] as Map).map((key, value) =>
//           MapEntry(int.parse(key), EpisodeProgress.fromJson(value))),
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'lastSeen': lastSeen,
//       'ep_index': episodeListIndex,
//       'progress': progress
//           .map((key, value) => MapEntry(key.toString(), value.toJson())),
//     };
//   }

//   AnimeProgress copyWith({
//     int? lastSeen,
//     int? episodeListIndex,
//     Map<int, EpisodeProgress>? progress,
//   }) {
//     return AnimeProgress(
//       lastSeen: lastSeen ?? this.lastSeen,
//       episodeListIndex: episodeListIndex ?? this.episodeListIndex,
//       progress: progress ?? this.progress,
//     );
//   }
// }
