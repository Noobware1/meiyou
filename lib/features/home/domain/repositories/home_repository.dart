import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/features/home/domain/models/repository_params/home_page_repository_params.dart';

abstract class HomeRepository {
  List<ExpandedHomePageList> expandHomePage(ExpandHomePageParams params);
}
