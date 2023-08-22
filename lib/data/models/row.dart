import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/domain/entities/row.dart';

class MetaRow extends MetaRowEntity {
  const MetaRow({
    required super.rowTitle,
    super.loadMoreData,
    required super.resultsEntity,
  });

  factory MetaRow.buildBannerList(
      List<MetaResponse> list1, List<MetaResponse> list2) {
    List<MetaResponse> jumbledList = [];
    int maxLength = list1.length > list2.length ? list1.length : list2.length;
    for (int i = 0; i < maxLength; i++) {
      if (i < list1.length) jumbledList.add(list1[i]);
      if (i < list2.length) jumbledList.add(list2[i]);
    }
    return MetaRow(
        loadMoreData: null,
        resultsEntity: MetaResults(totalPage: 1, metaResponses: jumbledList),
        rowTitle: 'banner');
  }
}
