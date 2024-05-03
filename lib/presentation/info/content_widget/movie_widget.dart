import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/core/episode_holder.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MovieWidget extends StatelessWidget implements ContentWidget {
  const MovieWidget({
    super.key,
    required this.content,
    required this.onSelected,
  });

  @override
  final void Function() onSelected;

  @override
  final Movie content;

  @override
  Widget build(BuildContext context) {
    return CardHolder.Movie(
      onTap: onSelected,
      title: title,
      movie: content,
      fallbackImage: InjectKtor.get<InfoScreenCubit>()
          .state
          .value!
          .let((it) => it.bannerImage ?? it.posterImage),
    );
  }

  String get title => InjectKtor.get<InfoScreenCubit>().state.value!.name;
}
