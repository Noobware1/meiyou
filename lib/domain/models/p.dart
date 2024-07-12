import 'package:isar/isar.dart';
import 'package:meiyou/extension/models/entension_type.dart';
part 'p.g.dart';

// abstract class ProgressKey {
//   final Id id;

//   ProgressKey({required this.id});
//   Map<String, dynamic> toJson();
//   factory ProgressKey.fromJson(Map<String, dynamic> json) {
//     throw UnimplementedError();
//   }
// }

// class MovieProgressKey extends ProgressKey {
//   MovieProgressKey({
//     required super.id,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//     };
//   }

//   factory MovieProgressKey.fromJson(Map<String, dynamic> json) {
//     final id = json['id'] as int;
//     return MovieProgressKey(
//       id: id,
//     );
//   }
// }

// class AnimeProgressKey extends ProgressKey {
//   final int episodeListIndex;
//   final int episodeIndex;

//   AnimeProgressKey({
//     required super.id,
//     required this.episodeListIndex,
//     required this.episodeIndex,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'ep_list': episodeListIndex,
//       'ep': episodeIndex,
//     };
//   }

//   factory AnimeProgressKey.fromJson(Map<String, dynamic> json) {
//     final id = json['id'] as int;
//     final episodeListIndex = json['ep_list'] as int;
//     final episodeIndex = json['ep'] as int;
//     return AnimeProgressKey(
//       id: id,
//       episodeListIndex: episodeListIndex,
//       episodeIndex: episodeIndex,
//     );
//   }
// }

// class SeriesProgressKey extends ProgressKey {
//   final int seasonIndex;
//   final int episodeListIndex;
//   final int episodeIndex;

//   SeriesProgressKey({
//     required super.id,
//     required this.seasonIndex,
//     required this.episodeListIndex,
//     required this.episodeIndex,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'season': seasonIndex,
//       'ep_list': episodeListIndex,
//       'ep': episodeIndex,
//     };
//   }

//   factory SeriesProgressKey.fromJson(Map<String, dynamic> json) {
//     final id = json['id'] as int;
//     final seasonIndex = json['season'] as int;
//     final episodeListIndex = json['ep_list'] as int;
//     final episodeIndex = json['ep'] as int;
//     return SeriesProgressKey(
//       id: id,
//       seasonIndex: seasonIndex,
//       episodeListIndex: episodeListIndex,
//       episodeIndex: episodeIndex,
//     );
//   }
// }

abstract class ContentProgress {
  abstract final Id id;

  static int generateId(String title, int sourceId, ExtensionType type) {
    return title.hashCode ^ sourceId.hashCode ^ type.hashCode;
  }
}

abstract class Progress {
  final int positionMilliseconds;
  final int durationMilliseconds;

  Progress(
      {required this.positionMilliseconds, required this.durationMilliseconds});

  @ignore
  Duration get position => Duration(milliseconds: positionMilliseconds);
  @ignore
  Duration get duration => Duration(milliseconds: durationMilliseconds);
}

@embedded
class EpisodeProgress extends Progress {
  final int episodeIndex;
  EpisodeProgress({
    this.episodeIndex = -1,
    int positionMilliseconds = -1,
    int durationMilliseconds = -1,
  }) : super(
            positionMilliseconds: positionMilliseconds,
            durationMilliseconds: durationMilliseconds);

  EpisodeProgress copyWith({
    int? episodeIndex,
    int? positionMilliseconds,
    int? durationMilliseconds,
  }) {
    return EpisodeProgress(
      episodeIndex: episodeIndex ?? this.episodeIndex,
      positionMilliseconds: positionMilliseconds ?? this.positionMilliseconds,
      durationMilliseconds: durationMilliseconds ?? this.durationMilliseconds,
    );
  }
}

@collection
class MovieProgress extends Progress implements ContentProgress {
  @override
  final Id id;

  MovieProgress({
    required this.id,
    required super.positionMilliseconds,
    required super.durationMilliseconds,
  });
}

@collection
class AnimeProgress implements ContentProgress {
  @override
  final Id id;
  final int episodeListIndex;
  final int episodeIndex;
  final List<EpisodeProgress> episodeProgress;

  AnimeProgress({
    required this.id,
    required this.episodeListIndex,
    required this.episodeIndex,
    required this.episodeProgress,
  });
}

@embedded
class SeasonProgress {
  final int seasonIndex;
  final List<EpisodeProgress> episodeProgress;

  SeasonProgress({
    this.seasonIndex = -1,
    this.episodeProgress = const [],
  });
}

@collection
class SeriesProgress implements ContentProgress {
  @override
  final Id id;
  @enumerated
  final int seasonIndex;
  final int episodeListIndex;
  final int episodeIndex;
  final List<SeasonProgress> seasonProgress;

  SeriesProgress({
    required this.id,
    required this.seasonIndex,
    required this.episodeListIndex,
    required this.episodeIndex,
    required this.seasonProgress,
  });
}
