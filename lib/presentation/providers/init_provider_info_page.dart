import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/media_item/anime.dart';
import 'package:meiyou/data/models/media_item/tv_series.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/season_cubit.dart';

Widget initProvidersForInfoPage(
    {required MediaDetailsEntity mediaDetails, required Widget child}) {
  if (mediaDetails.mediaItem is TvSeries) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EpisodesCubit()),
        BlocProvider(
            create: (context) =>
                EpisodesSelectorCubit(context.bloc<EpisodesCubit>())),
        BlocProvider(
            create: (context) => SeasonCubit(
                (mediaDetails.mediaItem as TvSeries).data.first,
                context.bloc<EpisodesCubit>())),
      ],
      child: child,
    );
  } else if (mediaDetails.mediaItem is Anime) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                EpisodesCubit((mediaDetails.mediaItem as Anime).episodes)),
        BlocProvider(
            create: (context) =>
                EpisodesSelectorCubit(context.bloc<EpisodesCubit>())),
      ],
      child: child,
    );
  } else {
    return child;
  }
}