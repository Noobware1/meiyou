import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/constraints_box_for_large_screen.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/episode_selector/episode_selector_bloc.dart';

import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/fetch_episodes/fetch_episodes_bloc.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';

class EpisodeSelector extends StatefulWidget {
  const EpisodeSelector({super.key});

  @override
  State<EpisodeSelector> createState() => _EpisodeSelectorState();
}

class _EpisodeSelectorState extends State<EpisodeSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;
    return BlocBuilder<SelectedSearchResponseBloc, SelectedSearchResponseState>(
      builder: (context, state) {
        if (state.searchResponse.type == MediaType.movie) {
          return defaultSizedBox;
        }
        return BlocBuilder<FetchSeasonsEpisodesBloc, FetchSeasonsEpisodesState>(
          builder: (context, state) {
            if (state is FetchSeasonsEpisodesSucess) {
              return BlocBuilder<SeasonsSelectorBloc, SeasonsSelectorState>(
                  builder: (context, season) {
                if (season.season == -1) {
                  return defaultSizedBox;
                }
                final episodes = season.episodes.entries.toList();
                if (episodes.length == 1) {
                  return defaultSizedBox;
                }

                return BlocBuilder<EpisodeSelectorBloc, EpisodeSelectorState>(
                    builder: (context, state) {
                  if (state.current.isEmpty && state.episodes.isEmpty) {
                    return defaultSizedBox;
                  } else {
                    return ResponsiveBuilder(
                        forSmallScreen: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: _BuildSelector(
                              episodes: episodes,
                              current: state.current,
                              primaryColor: primaryColor,
                              episodeSelector:
                                  BlocProvider.of<EpisodeSelectorBloc>(
                                      context)),
                        ),
                        forLagerScreen: ConstarintsForBiggerScreeen(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50, right: 20),
                            child: _BuildSelector(
                                episodes: episodes,
                                showScrollBar: true,
                                current: state.current,
                                primaryColor: primaryColor,
                                episodeSelector:
                                    BlocProvider.of<EpisodeSelectorBloc>(
                                        context)),
                          ),
                        ));
                  }
                });
              });
            } else {
              return defaultSizedBox;
            }
          },
        );
      },
    );
  }
}

class _BuildSelector extends StatefulWidget {
  const _BuildSelector({
    super.key,
    required this.episodes,
    required this.current,
    this.showScrollBar = false,
    required this.primaryColor,
    required this.episodeSelector,
  });

  final List<MapEntry<String, List<EpisodeEntity>>> episodes;
  final Color primaryColor;
  final EpisodeSelectorBloc episodeSelector;
  final String current;
  final bool showScrollBar;

  @override
  State<_BuildSelector> createState() => _BuildSelectorState();
}

class _BuildSelectorState extends State<_BuildSelector> {
  late final ScrollController? _controller;

  @override
  void initState() {
    if (widget.showScrollBar) {
      _controller = ScrollController();
    } else {
      _controller = null;
    }
    super.initState();
  }

  Widget _buildSrollBar({required Widget child}) {
    if (!widget.showScrollBar) return child;
    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        thumbColor: MaterialStatePropertyAll(Colors.grey),
      ),
      child: Scrollbar(
        controller: _controller,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: context.screenWidth,
      child: _buildSrollBar(
        child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, i) => addHorizontalSpace(10),
            itemCount: widget.episodes.length,
            itemBuilder: (context, index) {
              final isNotSelected =
                  widget.current != widget.episodes[index].key;
              return Material(
                color: isNotSelected ? Colors.black : widget.primaryColor,
                animationDuration: animationDuration,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  splashColor: widget.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    if (isNotSelected) {
                      widget.episodeSelector
                          .add(SelectEpisode(widget.episodes[index]));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color:
                              isNotSelected ? Colors.grey : widget.primaryColor,
                          width: 2),
                    ),
                    child: Text(widget.episodes[index].key,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
