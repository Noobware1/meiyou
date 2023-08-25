import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/date_titme.dart';
import 'package:meiyou/data/repositories/get_episodes_repository_impl.dart';
import 'package:meiyou/data/repositories/get_provider_list.dart';
import 'package:meiyou/data/repositories/watch_provider_repository_impl.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/get_episodes_repository.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/presentation/pages/info_watch/state/read_json.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/constraints_box_for_large_screen.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_providers_use_case.dart';
import 'package:meiyou/data/repositories/cache_repository_impl.dart';
import 'package:meiyou/presentation/widgets/info/episode_number_and_buttons.dart';
import 'package:meiyou/presentation/widgets/info/header.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/resizeable_text.dart';
import 'package:meiyou/presentation/widgets/season_selector/fetch_seasons_bloc/fetch_seasons_bloc_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/season_selector.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/source_dropdown.dart';
import 'package:meiyou/presentation/widgets/watch/search_response_bottom_sheet.dart';

class InfoAndWatchPage extends StatefulWidget {
  final MetaResponseEntity response;
  const InfoAndWatchPage({required this.response, super.key});

  @override
  State<InfoAndWatchPage> createState() => _InfoAndWatchPageState();
}

class _InfoAndWatchPageState extends State<InfoAndWatchPage> {
  late final Map<String, BaseProvider> providers;
  late final SourceDropDownBloc _sourceDropDownBloc;
  late final MediaDetailsEntity media;
  late final MetaProviderRepository _metaProviderRepository;
  late final WatchProviderRepository repository;
  late final SelectedSearchResponseBloc _selectedSearchResponseBloc;
  late final SearchResponseBloc _searchResponseBloc;
  late final FetchSeasonsBloc _fetchSeasonsBloc;
  late final SeasonsSelectorBloc _seasonsSelectorBloc;
  late final CacheRespository _cacheRespository;
  late final GetEpisodesRepository _getEpisodesRepository;

  static const _textStyleForEntryName =
      TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600);

  static const _textStyleForEntry =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700);

  @override
  void initState() {
    media = readMedia(2);
    providers = LoadProvidersUseCase(GetProviderListRepositoryImpl())
        .call(media.mediaType);
    _metaProviderRepository =
        RepositoryProvider.of<MetaProviderRepository>(context);
    final defaultProvider = providers.values.first;
    _cacheRespository = CacheRepositoryImpl();
    repository = WatchProviderRepositoryImpl(media);
    _selectedSearchResponseBloc = SelectedSearchResponseBloc(repository);
    _searchResponseBloc =
        SearchResponseBloc(repository, _selectedSearchResponseBloc);
    _sourceDropDownBloc = SourceDropDownBloc(
        repository: repository,
        searchResponseBloc: _searchResponseBloc,
        provider: defaultProvider)
      ..add(SourceDropDownOnSelected(
        provider: defaultProvider,
      ));
    _seasonsSelectorBloc = SeasonsSelectorBloc();
    _fetchSeasonsBloc = FetchSeasonsBloc(repository, _seasonsSelectorBloc);
    _getEpisodesRepository = GetEpisodeRepositoryImpl(
        metaProviderRepository: _metaProviderRepository,
        cacheRespository: _cacheRespository,
        mediaDetails: media);

    super.initState();
  }

  @override
  void dispose() {
    _cacheRespository.deleteAllCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.primaryColor;
    final textStyle =
        TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600);

    return Scaffold(
        backgroundColor: Colors.black,
        body: MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(
                value: media,
              ),
              RepositoryProvider.value(value: repository),
              RepositoryProvider.value(value: _cacheRespository),
              RepositoryProvider.value(value: _getEpisodesRepository),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _sourceDropDownBloc),
                BlocProvider.value(value: _selectedSearchResponseBloc),
                BlocProvider.value(value: _fetchSeasonsBloc),
                BlocProvider.value(value: _seasonsSelectorBloc),
              ],
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InfoHeader(),
                    _episodeNumberAndButtons(media.totalEpisode),
                    addVerticalSpace(10),
                    _buildInfo(media, color),
                    addVerticalSpace(20),
                    BlocConsumer<SelectedSearchResponseBloc,
                            SelectedSearchResponseState>(
                        bloc: _selectedSearchResponseBloc,
                        listener: (context, state) {
                          if (state is SelectedSearchResponseNotFound) {
                            showSnackBAr(context, text: state.error.toString());
                          }
                        },
                        listenWhen: (a, b) =>
                            b is SelectedSearchResponseNotFound,
                        builder: (context, state) {
                          final child = Text(
                            state.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          );
                          return ResponsiveBuilder(
                              forSmallScreen: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: child,
                              ),
                              forLagerScreen: ConstarintsForBiggerScreeen(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 20),
                                    child: child),
                              ));
                        }),
                    addVerticalSpace(5),
                    BlocProvider.value(
                      value: _sourceDropDownBloc,
                      child: ResponsiveBuilder(
                        forSmallScreen: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SourceDropDown(providersList: providers),
                        ),
                        forLagerScreen: ConstarintsForBiggerScreeen(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 20),
                          child: SourceDropDown(providersList: providers),
                        )),
                      ),
                    ),
                    addVerticalSpace(5),
                    _buildWrongTitle(context, textStyle),
                    addVerticalSpace(10),
                    const SeasonSelector(),
                    addVerticalSpace(20),
                    _synopsis(media.description),
                    addVerticalSpace(20),
                  ],
                ),
              ),
            )));
  }

  Widget _buildWrongTitle(BuildContext context, TextStyle textStyle) {
    return GestureDetector(
        onTap: () => showSearchBottomSheet(context),
        child: ResponsiveBuilder(
            forSmallScreen: Padding(
                padding: const EdgeInsets.only(right: 30, left: 20),
                child: _wrongTitle(textStyle)),
            forLagerScreen: ConstarintsForBiggerScreeen(
              child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 50),
                  child: _wrongTitle(textStyle)),
            )));
  }

  Widget _wrongTitle(TextStyle textStyle) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Wrong title',
        style: textStyle,
      ),
    );
  }

  Future showSearchBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        builder: (context) => SearchResponseBottomSheet(
              bloc: _searchResponseBloc,
              selectedSearchResponseBloc: _selectedSearchResponseBloc,
            ));
  }

  Widget _buildInfo(MediaDetailsEntity media, Color primaryColor) {
    return ResponsiveBuilder(
      forSmallScreen: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: _buildFields(media,
            primaryColor: primaryColor,
            textStyleForEntry: _textStyleForEntry.copyWith(fontSize: 14),
            textStyleForEntryName:
                _textStyleForEntryName.copyWith(fontSize: 14)),
      ),
      forLagerScreen: ConstarintsForBiggerScreeen(
        child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 20),
            child: _buildFields(media,
                primaryColor: primaryColor,
                textStyleForEntry: _textStyleForEntry,
                textStyleForEntryName: _textStyleForEntryName)),
      ),
    );
  }

  Widget _buildFields(MediaDetailsEntity media,
      {TextStyle? textStyleForEntryName,
      TextStyle? textStyleForEntry,
      required Color primaryColor}) {
    final textStyle = textStyleForEntry?.copyWith(
            color: primaryColor, fontWeight: FontWeight.w700) ??
        _textStyleForEntry.copyWith(
            color: primaryColor, fontWeight: FontWeight.w700);

    return Column(children: [
      _buildEntries(
          entryName: 'Average score',
          textStyleForEntryName: textStyleForEntryName,
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: media.averageScore.toStringAsFixed(1), style: textStyle),
            TextSpan(
                text: ' / 10', style: textStyle.copyWith(color: Colors.white))
          ]))),
      addVerticalSpace(5),
      _buildEntries(
          entryName: 'Format',
          entry: media.mediaType.toUpperCase(),
          textStyleForEntry: textStyleForEntry,
          textStyleForEntryName: textStyleForEntryName),
      addVerticalSpace(5),
      _buildEntries(
          entryName: 'Start Date',
          entry: media.startDate?.toFormattedString(),
          textStyleForEntry: textStyleForEntry,
          textStyleForEntryName: textStyleForEntryName),
      addVerticalSpace(5),
      _buildEntries(
          entryName: 'End Date',
          entry: media.endDate?.toFormattedString(),
          textStyleForEntry: textStyleForEntry,
          textStyleForEntryName: textStyleForEntryName),
      if (media.mediaType != MediaType.movie) ...[
        addVerticalSpace(5),
        _buildEntries(
            entryName: 'total Episodes',
            entry: '0 | ${media.totalEpisode?.toString() ?? "~"}',
            textStyleForEntry: textStyleForEntry,
            textStyleForEntryName: textStyleForEntryName)
      ]
    ]);
  }

  // Widget _buildRecommended(List<RecommendationsEnitiy> recommendations) {
  //   final row = MetaRowEntity(
  //       rowTitle: 'Recommend',
  //       resultsEntity: MetaResultsEntity(
  //           metaResponses:
  //               recommendations.map((e) => e.toMetaResponse()).toList(),
  //           totalPage: 1));

  //   return ResponsiveBuilder(
  //       forSmallScreen: ImageViewWithScrollController(
  //           type: ImageListViewType.withLabel, data: row),
  //       forLagerScreen: ImageViewWithScrollController(
  //           type: ImageListViewType.withButtonAndLabel,
  //           height: 250,
  //           width: 150,
  //           textStyle: const TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //           ),
  //           data: row));
  // }

  Widget _buildEntries({
    required String entryName,
    TextStyle? textStyleForEntryName,
    Widget? child,
    String? entry,
    TextStyle? textStyleForEntry,
  }) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              entryName,
              style: textStyleForEntryName ?? _textStyleForEntryName,
            ),
          ),
        ),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: child ??
                    Text(
                      entry ?? 'Unknown',
                      style: textStyleForEntry ?? _textStyleForEntry,
                    )))
      ],
    );
  }

  Widget _episodeNumberAndButtons(int? totalEpisodes) {
    return ResponsiveBuilder(
        forSmallScreen: Padding(
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
          child: EpisodeNumberAndButtons(
            total: totalEpisodes,
            watched: 0,
          ),
        ),
        forLagerScreen: ConstarintsForBiggerScreeen(
            child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 20, top: 10),
          child: EpisodeNumberAndButtons(
            total: totalEpisodes,
            watched: 0,
          ),
        )));
  }

  Widget _synopsis(String desc) {
    return ResponsiveBuilder(
        forSmallScreen: Padding(
          padding: const EdgeInsets.only(left: 30, right: 20),
          child: _showSynopsis(desc),
        ),
        forLagerScreen: ConstarintsForBiggerScreeen(
          child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 20),
              child: _showSynopsis(desc)),
        ));
  }

  Widget _showSynopsis(String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Synopsis',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        addVerticalSpace(10),
        ResizeableTextWidget(
          showButtons: true,
          text: desc,
          maxLines: 4,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
