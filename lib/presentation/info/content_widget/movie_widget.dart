import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/presentation/core/card_holder.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MovieWidget extends StatelessWidget implements ContentWidget {
  const MovieWidget({
    super.key,
    required this.content,
    this.contentProgress,
    required this.onSelected,
  });

  @override
  final void Function() onSelected;

  @override
  final Movie content;

  @override
  final MovieProgress? contentProgress;

  @override
  Widget build(BuildContext context) {
    return CardHolder.Movie(
      onTap: onSelected,
      title: title,
      movie: content,
      fallbackImage: getIt.get<InfoScreenNotifer>()
          .state
          .value!
          .let((it) => it.bannerImage ?? it.posterImage),
      progress: contentProgress,
    );
  }

  String get title => getIt.get<InfoScreenNotifer>().state.value!.name;
}
