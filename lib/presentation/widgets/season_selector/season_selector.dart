import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/button_style.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/constraints_box_for_large_screen.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/season_selector/fetch_seasons_bloc/fetch_seasons_bloc_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';

class SeasonSelector extends StatefulWidget {
  const SeasonSelector({super.key});

  @override
  State<SeasonSelector> createState() => _SeasonSelectorState();
}

class _SeasonSelectorState extends State<SeasonSelector> {
  late final SourceDropDownBloc sourceDropDownBloc;
  late final SelectedSearchResponseBloc selectedSearchResponseBloc;
  late final FetchSeasonsBloc fetchBloc;
  late final SeasonsSelectorBloc seasonsSelectorBloc;

  @override
  void initState() {
    sourceDropDownBloc = BlocProvider.of<SourceDropDownBloc>(context);
    selectedSearchResponseBloc =
        BlocProvider.of<SelectedSearchResponseBloc>(context);
    fetchBloc = BlocProvider.of<FetchSeasonsBloc>(context);
    seasonsSelectorBloc = BlocProvider.of<SeasonsSelectorBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceDropDownBloc, SourceDropDownState>(
      bloc: sourceDropDownBloc,
      builder: (context, state) {
        final provider = state.provider;

        return BlocBuilder<SelectedSearchResponseBloc,
            SelectedSearchResponseState>(
          buildWhen: (a, b) => a.searchResponse.url != b.searchResponse.url,
          bloc: selectedSearchResponseBloc,
          builder: (context, state2) {
            if (state2.searchResponse.isEmpty) {
              return defaultSizedBox;
            }
            return BlocConsumer<FetchSeasonsBloc, FetchSeasonsState>(
                bloc: fetchBloc
                  ..add(FetchSeasons(provider, state2.searchResponse)),
                builder: (context, state3) {
                  if (state3 is FetchSeasonsSuccess) {
                    print('rebuild');
                    return BlocBuilder<SeasonsSelectorBloc,
                            SeasonsSelectorState>(
                        bloc: seasonsSelectorBloc,
                        builder: (context, state4) {
                          final text = 'Season ${state4.season.number}';
                          if ((state4 as SeasonSelected).season.isEmpty) {
                            return defaultSizedBox;
                          }
                          return ResponsiveBuilder(
                            forSmallScreen: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: ElevatedButton(
                                  style: MeiyouButtonStyle(
                                      minimumSize: const Size(100, 50),
                                      maximumSize: const Size(120, 50),
                                      //fixedSize: const Size(100, 50),
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                      textStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                                  onPressed: () => showSeasonSelector(context,
                                      currentSeason: state4.season,
                                      bloc: seasonsSelectorBloc,
                                      seasons: state3.seasons!),
                                  child: Text(text)),
                            ),
                            forLagerScreen: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: ElevatedButton(
                                  style: MeiyouButtonStyle(
                                      minimumSize: const Size(100, 50),
                                      maximumSize: const Size(120, 50),
                                      //fixedSize: const Size(100, 50),
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                      textStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                                  onPressed: () => showSeasonSelector(context,
                                      currentSeason: state4.season,
                                      bloc: seasonsSelectorBloc,
                                      seasons: state3.seasons!),
                                  child: Text(text)),
                            ),
                          );
                        });
                  }
                  return defaultSizedBox;
                },
                listenWhen: (a, b) => b is FetchSeasonsFailed,
                listener: (context, state3) {
                  if (state3 is FetchSeasonsFailed) {
                    showSnackBAr(context,
                        text: state3.error?.toString() ?? 'lol');
                  }
                });
          },
        );
      },
    );
  }

  Future showSeasonSelector(BuildContext context,
      {required SeasonEntity currentSeason,
      required SeasonsSelectorBloc bloc,
      required List<SeasonEntity> seasons}) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            // insetPadding: EdgeInsets.all(40),
            elevation: 10,
            backgroundColor: Colors.black,

            child: Container(
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 280),
              // color: Colors.red,
              child: ListView.builder(
                  itemCount: seasons.length,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  itemBuilder: (context, index) {
                    return SelectedButton(
                      isSelected: currentSeason == seasons[index],
                      onTap: () {
                        final season = seasons[index];
                        if (currentSeason != season) {
                          bloc.add(SelectSeason(season));
                          Navigator.pop(context);
                        }
                      },
                      text: 'Season ${seasons[index].number}',
                    );
                  }),
            ),
          );
        });
  }
}

class SelectedButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  final String text;
  const SelectedButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: animationDuration,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
            // stream: null,
            builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (constraints.maxWidth < 65)
                  defaultSizedBox
                else
                  Visibility(
                    visible: isSelected,
                    replacement: const SizedBox(
                      height: 25,
                      width: 25,
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                addHorizontalSpace(20),
                Expanded(
                  child: Text(
                    text,
                    // textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
