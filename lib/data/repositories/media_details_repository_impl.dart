import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/mapping/anilist_to_tmdb.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/repositories/media_details_repository.dart';

class MediaDetailsRepositoryImpl implements MediaDetailsRepository {
  final Anilist _aniList;
  final TMDB _tmdb;

  MediaDetailsRepositoryImpl(this._aniList, this._tmdb);

  @override
  Future<ResponseState<MediaDetails>> getMediaDetails(
      MetaResponseEntity response) {
    return tryWithAsync(() async {
      final MediaDetails mediaDetails;
      if (response.mediaProvider == MediaProvider.tmdb &&
          (response as MetaResponse).isAnime()) {
        final map = await mapTmdbToAnilist(response, _aniList);
        if (map != null) {
          mediaDetails = map;
        } else {
          mediaDetails =
              await _tmdb.fetchMediaDetails(response.id, response.mediaType!);
        }
      } else if (response.mediaProvider == MediaProvider.anilist) {
        mediaDetails =
            await _aniList.fetchMediaDetails(response.id, response.mediaType!);
      } else {
        mediaDetails =
            await _tmdb.fetchMediaDetails(response.id, response.mediaType!);
      }
      return mediaDetails;
    });
  }
}
