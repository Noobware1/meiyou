import 'package:flutter/material.dart';
import 'package:streamify/constants/default_sized_box.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/widgets/image_view/image_list_view.dart';
import 'package:streamify/widgets/info/info_list_view.dart';

Widget buildCast(List<Cast>? cast) => cast != null
    ? BuildInfoListView(
        height: 180,
        width: 110,
        data: cast
            .map((data) => ImageListViewData(
                imageUrl: data.image ?? '',
                text: data.name ?? data.originalName ?? '',
                onTap: () {}))
            .toList(),
        label: 'Cast')
    : defaultSizedBox;
