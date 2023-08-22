import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/domain/repositories/meta_results_repository.dart';

class MetaResultsRepositoryImpl implements MetaResultsRepository {
  final Anilist _anilist;
  final TMDB _tmdb;

  MetaResultsRepositoryImpl(this._anilist, this._tmdb);

  @override
  Future<ResponseState<MetaResults>> getSearch(String query,
      {int page = 1, bool isAdult = false}) async {
    try {
      final results = <MetaResponse>[];

      final future = await Future.wait([
        _tmdb.fetchSearch(query, page: page, isAdult: isAdult),
        _anilist.fetchSearch(query, page: page, isAdult: isAdult)
      ]);

      if (future[0] is ResponseSuccess) {
        results.addAll(future[0]
            .metaResponses
            .whereSafe((it) => !(it as MetaResponse).isAnime())
            .map((e) => MetaResponse.fromMetaResponsEntity(e)));
      }
      if (future[1] is ResponseSuccess) {
        results.addAll(future[1]
            .metaResponses
            .map((e) => MetaResponse.fromMetaResponsEntity(e)));
      }
      if (results.isNotEmpty) {
        return ResponseSuccess(
            MetaResults(totalPage: 1, metaResponses: results));
      }
      return const ResponseFailed(MeiyouException('Failed To Fetch Search',
          type: MeiyouExceptionType.providerException));
    } catch (_, __) {
      return ResponseFailed.defaultError(_, __);
    }
  }
}
