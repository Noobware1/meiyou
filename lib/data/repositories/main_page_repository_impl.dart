import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/main_page.dart';
import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/data/models/row.dart';
import 'package:meiyou/domain/repositories/main_page_repository.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';

class MainPageRepositoryImpl implements MainPageRepository {
  final Anilist _anilist;
  final TMDB _tmdb;

  MainPageRepositoryImpl(this._anilist, this._tmdb);

  @override
  Future<ResponseState<MainPage>> getMainPage() {
    return tryWithAsync(() async {
      final futures =
          await Future.wait([_anilist.fetchMainPage(), _tmdb.fetchMainPage()]);

      final rows = <MetaRow>[];

      rows.addAll([
        ...(futures[0].rows as List<MetaRow>),
        ...(futures[1].rows as List<MetaRow>)
      ]);

      final bannerRow = MetaRow.buildBannerList(
          rows
              .firstWhere((it) => it.rowTitle == 'Trending Anime')
              .resultsEntity
              .metaResponses
              .map((e) => MetaResponse.fromMetaResponsEntity(e))
              .toList(),
          rows
              .firstWhere((it) => it.rowTitle == 'Trending')
              .resultsEntity
              .metaResponses
              .map((e) => MetaResponse.fromMetaResponsEntity(e))
              .toList());

      return MainPage([bannerRow, ...rows]);
    });
  }
}

void main(List<String> args) async {}
