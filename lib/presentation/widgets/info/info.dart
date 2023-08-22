import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/widgets/info/cast.dart';
import 'package:streamify/widgets/info/meta_data_view.dart';
import 'package:streamify/widgets/info/recommendations.dart';
import 'package:streamify/widgets/info/synopsis.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<MediaDetails>(context, listen: false);
    return Column(children: [
      MetaDataView(data: MetaFieldsData.fromMediaDetails(media)),
      addVerticalSpace(40),
      BuildSynopsis(text: media.description),
      addVerticalSpace(60),
      buildCast(media.cast),
      addVerticalSpace(20),
      buildRecommened(media.recommendations)
    ]);
  }
}
