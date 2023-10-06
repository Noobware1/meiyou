import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/button_style.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/utils/add_padding_onrientation_change.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/arrow_selector_list.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/season_selector/bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';

class SeasonSelector extends StatefulWidget {
  const SeasonSelector({
    super.key,
  });

  @override
  State<SeasonSelector> createState() => _SeasonSelectorState();
}

class _SeasonSelectorState extends State<SeasonSelector> {
  late final SourceDropDownBloc sourceDropDownBloc;
  late final FetchSeasonsEpisodesBloc fetchSeasonsEpisodesBloc;
  late final SeasonsSelectorBloc seasonsSelectorBloc;
  late final SelectedSearchResponseBloc searchResponseBloc;

  @override
  void initState() {
    super.initState();

    sourceDropDownBloc = BlocProvider.of<SourceDropDownBloc>(context);
    fetchSeasonsEpisodesBloc =
        BlocProvider.of<FetchSeasonsEpisodesBloc>(context);
    seasonsSelectorBloc = BlocProvider.of<SeasonsSelectorBloc>(context);
    searchResponseBloc = BlocProvider.of<SelectedSearchResponseBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceDropDownBloc, SourceDropDownState>(
        bloc: sourceDropDownBloc,
        builder: (context, state) {
          final provider = state.provider;
          return BlocBuilder<SelectedSearchResponseBloc,
              SelectedSearchResponseState>(
            bloc: searchResponseBloc,
            builder: (context, state) {
              if (state.searchResponse.type != MediaType.tvShow) {
                return defaultSizedBox;
              }
              return BlocBuilder<FetchSeasonsEpisodesBloc,
                  FetchSeasonsEpisodesState>(
                bloc: fetchSeasonsEpisodesBloc,
                builder: (context, state3) {
                  if (state3 is FetchSeasonsEpisodesSucess) {
                    return BlocBuilder<SeasonsSelectorBloc,
                            SeasonsSelectorState>(
                        bloc: seasonsSelectorBloc,
                        builder: (context, state4) {
                          final text = 'Season ${state4.season}';

                          if (state4.season == -1) {
                            return defaultSizedBox;
                          }

                          return ResponsiveBuilder(
                            forSmallScreen: Padding(
                              padding: addPaddingOnOrientation(context),
                              child: ElevatedButton(
                                  style: MeiyouButtonStyle(
                                      minimumSize: const Size(100, 50),
                                      maximumSize: const Size(120, 50),
                                      elevation: 4.0,
                                      surfaceTintColor:
                                          context.theme.colorScheme.tertiary,

                                      //fixedSize: const Size(100, 50),
                                      backgroundColor:
                                          context.theme.colorScheme.tertiary,
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: () => showSeasonSelector(context,
                                      currentSeason: state4.season,
                                      bloc: seasonsSelectorBloc,
                                      provider: provider,
                                      data: state3.data!.entries.toList()),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        color: context
                                            .theme.colorScheme.onSurface),
                                  )),
                            ),
                            forLagerScreen: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: ElevatedButton(
                                  style: MeiyouButtonStyle(
                                      minimumSize: const Size(100, 50),
                                      maximumSize: const Size(120, 50),
                                      //fixedSize: const Size(100, 50),
                                      elevation: 4.0,
                                      surfaceTintColor:
                                          context.theme.colorScheme.tertiary,
                                      backgroundColor:
                                          context.theme.colorScheme.tertiary,
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: () => showSeasonSelector(context,
                                      currentSeason: state4.season,
                                      bloc: seasonsSelectorBloc,
                                      provider: provider,
                                      data: state3.data!.entries.toList()),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        color: context
                                            .theme.colorScheme.onSurface),
                                  )),
                            ),
                          );
                        });
                  }
                  return defaultSizedBox;
                },
              );
            },
          );
        });
  }

  Future showSeasonSelector(BuildContext context,
      {required num currentSeason,
      required SeasonsSelectorBloc bloc,
      required BaseProvider provider,
      required List<MapEntry<num, List<EpisodeEntity>>> data}) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            // insetPadding: EdgeInsets.all(40),
            elevation: 10,

            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 300, maxHeight: 280, minHeight: 20),
              // color: Colors.red,
              child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    addVerticalSpace(10),
                    ...List.generate(data.length, (index) {
                      return ArrowSelector(
                        showArrow: currentSeason == data[index].key,
                        onTap: () {
                          final season = data[index].key;
                          if (currentSeason != season) {
                            bloc.add(SelectSeason(season, data[index].value));
                            Navigator.pop(context);
                          }
                        },
                        text: 'Season ${data[index].key}',
                      );
                    }),
                    addVerticalSpace(10)
                  ]),
            ),
          );
        });
  }
}

// class SelectedButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final bool isSelected;

//   final String text;
//   const SelectedButton({
//     super.key,
//     required this.isSelected,
//     required this.text,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       animationDuration: animationDuration,
//       type: MaterialType.transparency,
//       child: InkWell(
//         onTap: onTap,
//         child: LayoutBuilder(
//             // stream: null,
//             builder: (context, constraints) {
//           return Container(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 if (constraints.maxWidth < 65)
//                   defaultSizedBox
//                 else
//                   Visibility(
//                     visible: isSelected,
//                     replacement: const SizedBox(
//                       height: 30,
//                       width: 30,
//                     ),
//                     child: const Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Icon(
//                         Icons.done,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 addHorizontalSpace(20),
//                 Expanded(
//                   child: Text(
//                     text,
//                     // textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: isSelected ? Colors.white : Colors.grey,
//                         fontSize: 18),
//                   ),
//                 )
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
