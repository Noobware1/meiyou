import 'package:meiyou/domain/entities/search_response.dart';

class HomePageDataEntity {
  final String name;
  final String data;
  final bool horizontalImages;

  HomePageDataEntity(
      {required this.name, required this.data, required this.horizontalImages});
}

class HomePageRequestEntity {
  final String name;
  final String data;
  final bool horizontalImages;

  HomePageRequestEntity(
      {required this.name, required this.data, required this.horizontalImages});
}

class HomePageEntity {
  final HomePageListEntity data;
  final int page;
  final bool? hasNextPage;

  HomePageEntity({required this.data, required this.page, this.hasNextPage});
}

class HomePageListEntity {
  final String name;
  final List<SearchResponseEntity> data;
  // final Future<List<SearchResponse>> Function(int page)? loadMoreData;

  HomePageListEntity({
    required this.name,
    required this.data,
    //  this.loadMoreData
  });
}
