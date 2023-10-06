import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';

import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/core/usecases_container/provider_list_container.dart';
import 'package:meiyou/core/utils/add_padding_onrientation_change.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/date_titme.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/providers_repository_usecases/get_default_provider_usecase.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/constraints_box_for_large_screen.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_providers_use_case.dart';
import 'package:meiyou/presentation/widgets/info/episode_number_and_buttons.dart';
import 'package:meiyou/presentation/widgets/info/header.dart';
import 'package:meiyou/presentation/widgets/info/loading_widget.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/resizeable_text.dart';
import 'package:meiyou/presentation/widgets/watch/source_dropdown.dart';
import 'package:meiyou/core/initialization_view/intialise_view_type.dart';
import 'package:meiyou/core/initialization_view/initialise_view.dart';

class InfoPage extends StatefulWidget {
  final MediaDetailsEntity media;
  final InitaliseViewType type;
  const InfoPage({required this.type, super.key, required this.media});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool initalise = false;
  late final Map<String, BaseProvider> providers;
  late final MediaDetailsEntity media;
  // late final SourceDropDownBloc sourceDropDownBloc;
  late final InitialiseView initialiseView;

  static const _textStyleForEntryName = TextStyle(
      color: Color(0xFF5F6267), fontSize: 16, fontWeight: FontWeight.w600);

  static const _textStyleForEntry =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  @override
  void initState() {
    media = widget.media;

    final providerListContainer =
        RepositoryProvider.of<ProvidersRepositoryContainer>(context);
    providers =
        providerListContainer.get<LoadProvidersUseCase>().call(media.mediaType);
    final AppDirectories appDirectories =
        RepositoryProvider.of<AppDirectories>(context);

    providerListContainer
        .get<GetDefaultProviderUseCase>()
        .call(GetDefaultProviderUseCaseParams(
            RepositoryProvider.of<AppDirectories>(context)
                .appDocumentDirectory
                .path,
            providers.values.first.providerType))
        .then((value) {
      init(appDirectories, value);
      // sourceDropDownBloc = SourceDropDownBloc(defaultProvider)
      //   ..add(SourceDropDownOnSelected(provider: defaultProvider));
    }).timeout(const Duration(seconds: 3), onTimeout: () {
      init(appDirectories, null);
    }).catchError((e, s) {
      init(appDirectories, null);
    });

    super.initState();
  }

  init(AppDirectories appDirectories, BaseProvider? defaultProvider) {
    initialiseView = getViewFromType(InitializationViewParams(
      appDirectories: appDirectories,
      type: widget.type,
      media: media,
      cacheRespository: RepositoryProvider.of<CacheRespository>(context),
      metaProviderRepositoryContainer:
          RepositoryProvider.of<MetaProviderRepositoryContainer>(context),
      defaultProvider: defaultProvider ?? providers.values.first,
    ));

    initialiseView.initalise();
    setState(() {
      initalise = true;
    });
  }

  @override
  void dispose() {
    initialiseView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initalise) {
      return const LoadingWidget();
    }

    final color = context.theme.colorScheme.primary;
    final width = context.screenWidth;
    final textStyle =
        TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600);

    return Scaffold(
        body: RepositoryProvider.value(
      value: media,
      child: initialiseView.createBlocProvider(
        child: SingleChildScrollView(
          child: Stack(
            ///      fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoHeader(),
                  _episodeNumberAndButtons(media.totalEpisode),
                  addVerticalSpace(10),
                  _buildInfo(media, color),
                  addVerticalSpace(20),
                  _synopsis(media.description),
                  addVerticalSpace(20),
                  initialiseView.selectedSearchResponseWidget,
                  addVerticalSpace(5),
                  _soureDropDown(),
                  addVerticalSpace(5),
                  _buildWrongTitle(context, textStyle),
                  addVerticalSpace(10),
                  ...initialiseView.selectors,
                  addVerticalSpace(20),
                  ResponsiveBuilder(
                      forSmallScreen: initialiseView.view,
                      forLagerScreen: defaultSizedBox),
                  addVerticalSpace(70),
                ],
              ),
              if (width > smallScreenSize)
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, top: 50, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                        width: (width / 2), child: initialiseView.view),
                  ),
                ),
              Positioned(
                top: 50,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    //      color: Colors.red,
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: context.theme.colorScheme.secondary),
                    child: const Icon(
                      Icons.close,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildWrongTitle(BuildContext context, TextStyle textStyle) {
    return GestureDetector(
        onTap: () => showSearchBottomSheet(context),
        child: ResponsiveBuilder(
            forSmallScreen: Padding(
                padding: addPaddingOnOrientation(context),
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

  Widget _soureDropDown() {
    return ResponsiveBuilder(
      forSmallScreen: Padding(
        padding: addPaddingOnOrientation(context),
        child: SourceDropDown(providersList: providers),
      ),
      forLagerScreen: ConstarintsForBiggerScreeen(
          child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 20),
        child: SourceDropDown(providersList: providers),
      )),
    );
  }

  Future showSearchBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context, builder: (context) => initialiseView.search);
  }

  Widget _buildInfo(MediaDetailsEntity media, Color primaryColor) {
    return ResponsiveBuilder(
      forSmallScreen: Padding(
        padding: addPaddingOnOrientation(context),
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
          child: Text(
            media.averageScore.toStringAsFixed(1),
            style: textStyle,
          )),
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
          padding: addPaddingOnOrientation(context).copyWith(top: 10),
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
          padding: addPaddingOnOrientation(context),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        addVerticalSpace(10),
        ResizeableTextWidget(
          showButtons: true,
          text: desc,
          maxLines: 4,
          style: const TextStyle(
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
