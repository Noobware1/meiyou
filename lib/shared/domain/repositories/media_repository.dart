import 'dart:async';

import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class MediaRepository {
  Future<Result<Media>> networkMediaToLocal(NetworkMediaToLocalParams params);

  Media? getMediaById(GetMediaByIdParams params);

  Stream<Media?> getMediaByIdAsStream(GetMediaByIdAsStreamParams params);

  Media? getMediaByUrlAndSourceId(GetMediaByUrlAndSourceIdParams params);

  Future<int> insertMedia(InsertMediaParams params);

  Future<int> updateMedia(UpdateMediaParams params);

  Future<int> updateMediaFromSource(UpdateMediaFromSourceParams params);
}
