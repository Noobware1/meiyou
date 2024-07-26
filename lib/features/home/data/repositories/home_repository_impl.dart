import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/features/home/domain/models/repository_params/home_page_repository_params.dart';
import 'package:meiyou/features/home/domain/repositories/home_repository.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  List<ExpandedHomePageList> expandHomePage(ExpandHomePageParams params) {
    final homePage = params.homePage;
    final mapper = params.mapper;
    return homePage.items.mapList(
      (e) => ExpandedHomePageList(
        title: e.title,
        mediaList: e.list.mapList(mapper),
        horizontalImages: e.horizontalImages,
        hasNext: homePage.hasNextPage,
        currentPage: 1,
      ),
    );
  }

  
}
