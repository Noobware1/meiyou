import 'package:meiyou_extensions_lib/models.dart';

class HomePageData {
  final HomePageRequest request;
  final HomePage homePage;
  final int page;

  HomePageData({
    required this.request,
    required this.homePage,
    required this.page,
  });

  HomePageData copyWith({
    HomePageRequest? request,
    HomePage? homePage,
    int? page,
  }) {
    return HomePageData(
      request: request ?? this.request,
      homePage: homePage ?? this.homePage,
      page: page ?? this.page,
    );
  }
}
