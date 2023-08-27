import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/extenstions/async_snapshot.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_movie_usecase.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/episode_holder.dart';

class MovieView extends StatefulWidget {
  final SearchResponseEntity searchResponse;
  const MovieView({super.key, required this.searchResponse});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  late final MediaDetailsEntity media;
  // late final LoadMovieUseCase loadMovieUseCase;

  @override
  void initState() {
    media = RepositoryProvider.of<MediaDetailsEntity>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceDropDownBloc, SourceDropDownState>(
        bloc: BlocProvider.of<SourceDropDownBloc>(context),
        builder: (context, state) {
          final LoadMovieUseCase loadMovieUseCase = LoadMovieUseCase(
              repository:
                  RepositoryProvider.of<WatchProviderRepository>(context),
              provider: state.provider);
          return FutureBuilder(
              future: loadMovieUseCase.call(widget.searchResponse.url),
              builder: (context, snapshot) {
                if (snapshot.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.done &&
                    snapshot.hasData &&
                    snapshot.data is ResponseSuccess) {
                  return EpisodeHolder(
                    onTap: () {},
                    number: 0,
                    title: media.title ??
                        media.romaji ??
                        media.native ??
                        'No Title',
                    desc: media.description,
                    rated: media.averageScore,
                    thumbnail: media.bannerImage ?? media.poster,
                  );
                } else {
                  return defaultSizedBox;
                }
              });
        });
  }
}
