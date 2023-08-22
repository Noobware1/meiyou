import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/constants/default_sized_box.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/widgets/episode_holder.dart';

class MovieView extends StatelessWidget {
  final LoadResponse? loadResponse;
  const MovieView({super.key, required this.loadResponse});

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<MediaDetails>(context);
    if (loadResponse == null) defaultSizedBox;
    final data = loadResponse!.generateMovieResponse(media);
    return EpisodeHolder(
      onTap: () {},
      title: data.title ?? media.name ?? media.title ?? '',
      number: data.number,
      thumbnail: data.thumbnail,
      desc: data.desc,
      rated: data.rated,
    );
  }
}
