import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/features/home/domain/models/repository_params/home_page_repository_params.dart';
import 'package:meiyou/features/home/domain/repositories/home_repository.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<ExpandedHomePageList>> expandHomePage(
      ExpandHomePageParams params) async {
    final homePage = params.homePage;
    final mapper = params.mapper;

    return homePage.items
        .mapList((e) async => ExpandedHomePageList(
              title: e.title,
              mediaList: await e.list.mapList(mapper).wait,
              horizontalImages: e.horizontalImages,
              hasNext: homePage.hasNextPage,
              currentPage: 1,
            ))
        .wait;
  }
}
