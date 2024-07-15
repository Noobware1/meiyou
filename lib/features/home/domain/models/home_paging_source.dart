import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LoadHomePageParams {
  final int page;
  final HomePageRequest request;
  final bool hasNextPage;

  LoadHomePageParams({
    required this.page,
    required this.request,
    required this.hasNextPage,
  });
}

abstract class HomePagingSource
    extends PagingSource<HomePage, LoadHomePageParams> {
  HomePagingSource({
    required int page,
    required HomePageRequest request,
    required HomePage homePage,
  }) : super(
            value: homePage,
            params: LoadHomePageParams(
              page: page,
              request: request,
              hasNextPage: homePage.hasNextPage,
            ));

  @override
  LoadHomePageParams loadParams(LoadHomePageParams parmas) {
    return LoadHomePageParams(
      page: parmas.page + 1,
      request: parmas.request,
      hasNextPage: parmas.hasNextPage,
    );
  }

  @override
  HomePage map(HomePage a, HomePage b) {
    return a + b;
  }
}
