import 'package:meiyou/core/utils/unwrap.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/domain/entities/homepage.dart';

class HomePageData extends HomePageDataEntity {
  HomePageData({
    required super.name,
    required super.data,
    super.horizontalImages = false,
  });

  static Iterable<HomePageData> fromMap(Map<String, String> map,
      [bool horizontalImages = false]) {
    return map.entries.map((e) => HomePageData(
        name: e.key, data: e.value, horizontalImages: horizontalImages));
  }

  @override
  String toString() {
    return '''HomePageData(name: $name, data: $data, horizontalImages: $horizontalImages)''';
  }
}

class HomePageRequest extends HomePageRequestEntity {
  HomePageRequest({
    required super.name,
    required super.data,
    required super.horizontalImages,
  });

  @override
  String toString() {
    return '''HomePageRequest(name: $name, data: $data, horizontalImages: $horizontalImages)''';
  }
}

class HomePage extends HomePageEntity {
  @override
  HomePageList get data => super.data as HomePageList;

  HomePage({required super.data, super.page = 1, super.hasNextPage});

  @override
  String toString() {
    return '''HomePage(data: ${unwrapValue<HomePageList>(data)}, page: $page, hasNextPage: $hasNextPage)''';
  }
}

class HomePageList extends HomePageListEntity {
  @override
  List<SearchResponse> get data => super.data as List<SearchResponse>;

  HomePageList({
    required super.name,
    required super.data,
  });

  @override
  String toString() {
    return '''HomePageList(name: $name, data: ${unwrapList<SearchResponse>(data)}, loadMoreData: \$loadMoreData)''';
  }
}
