import 'package:flutter/material.dart';
import 'package:streamify/constants/default_sized_box.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/widgets/image_view/image_list_view.dart';
import 'package:streamify/widgets/info/info_list_view.dart';

Widget buildRecommened(List<Recommendations>? recommed) => recommed != null
    ? BuildInfoListView(
        data: recommed.map((data) {
          final recommendation = data.recommeded;
          return ImageListViewData(
              imageUrl: recommendation.poster ?? '',
              text: recommendation.name ?? recommendation.title ?? '',
              onTap: () {});
        }).toList(),
        label: 'Recommeded')
    : defaultSizedBox;
