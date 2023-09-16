import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/widgets/not_found.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/anime_view.dart';
import 'package:meiyou/presentation/widgets/watch/movie_view.dart';
import 'package:meiyou/presentation/widgets/watch/tv_view.dart';

class WatchView extends StatelessWidget {
  final void Function(SelectedServer server)? onServerSelected;
  final void Function(EpisodeEntity episode)? onEpisodeSelected;

  const WatchView({
    super.key,
    this.onServerSelected, this.onEpisodeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedSearchResponseBloc, SelectedSearchResponseState>(
        builder: (context, state) {
      if ((state is SelectedSearchResponseFound ||
              state is SelectedSearchResponseSelected) &&
          !state.searchResponse.isEmpty) {
        final searchReponse = state.searchResponse;
        switch (searchReponse.type) {
          case MediaType.anime:
            return AnimeView(
              onServerSelected: onServerSelected,
              onEpisodeSelected: onEpisodeSelected,
            );
          case MediaType.movie:
            return MovieView(
              onServerSelected: onServerSelected,
            );
          case MediaType.tvShow:
            return TvView(
              onServerSelected: onServerSelected,
              onEpisodeSelected: onEpisodeSelected,
            );
          default:
            return defaultSizedBox;
        }
      } else if (state is SelectedSearchResponseNotFound) {
        return const NotFound();
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
