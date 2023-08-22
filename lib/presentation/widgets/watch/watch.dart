import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/constants/colors.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/utils.dart';
import 'package:streamify/notifers/search_response_notifer.dart';
import 'package:streamify/notifers/watch_notifer.dart';
import 'package:streamify/providers/base_parser.dart';
import 'package:streamify/providers/meta_providers/main_api.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/providers/providers.dart';
import 'package:streamify/utils/check_connection_state.dart';
import 'package:streamify/utils/find_best.dart';
import 'package:streamify/utils/http_error_handler.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/widgets/not_found.dart';
import 'package:streamify/widgets/perfect_loading_indicator.dart';
import 'package:streamify/widgets/search_bottom_sheet.dart';
import 'package:streamify/widgets/watch/selected_response_text.dart';
import 'package:streamify/widgets/watch/source_dropdown.dart';
import 'package:streamify/widgets/watch/watch_view.dart';

class Watch extends StatefulWidget {
  const Watch({
    super.key,
  });

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  late final MediaDetails media;
  late final List<Lazier<BaseParser>> sources;
  late final Future<Map<String, List<Episode>>?> episodes;

  late BaseParser source;

  @override
  void initState() {
    media = Provider.of(context, listen: false);
    sources = providers.get(media.sourceType == SourceType.mediaAnilist);
    source = sources.first.provider;
    if (media.mediaType != MediaType.movie) {
      episodes = tryWithAsync(context, () => mainApi.fetchEpisode(media));
    }
    super.initState();
  }

  String title() => media.name ?? media.title ?? '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: episodes,
        builder: (context, snapshot) {
          if (waiting(snapshot)) {
            return const PerfectLoadingIndicator();
          } else if (done(snapshot)) {
            return _buildMain(snapshot.data!);
          } else {
            return _buildMain(null);
          }
        });
  }

  _buildMain(Map<String, List<Episode>>? episode) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => episode),
        ChangeNotifierProvider(
          create: (context) => WatchNotifer(
              parser: source,
              futureSearchResponse:
                  tryWithAsync(context, () => providers.search(source, media))),
          child: _buildWhenWaiting(),
        ),
      ],
      builder: (context, child) {
        return Consumer<WatchNotifer>(
          builder: (context, watchNotifer, noDataWidget) {
            return FutureBuilder(
                future: watchNotifer.futureSearchResponse,
                builder: (context, snapshot) {
                  final SearchResponse? searchResponse =
                      done(snapshot) && snapshot.data!.isNotEmpty
                          ? findBestSearchResponse(snapshot.data!, media)
                          : null;

                  return ChangeNotifierProxyProvider<WatchNotifer,
                      SearchResponseNotifer>(
                    update: (context, value, previous) => SearchResponseNotifer(
                        future: value.futureSearchResponse,
                        searchResponse: searchResponse,
                        parser: value.parser,
                        responses: snapshot.data ?? []),
                    create: (context) => SearchResponseNotifer(
                        future: watchNotifer.futureSearchResponse,
                        searchResponse: searchResponse,
                        parser: watchNotifer.parser,
                        responses: snapshot.data ?? []),
                    builder: (context, waitingWidget) {
                      if (waiting(snapshot)) {
                        return waitingWidget!;
                      } else if (done(snapshot) && searchResponse != null) {
                        return _buildWhenDone();
                      } else {
                        return noDataWidget!;
                      }
                    },
                    child: _buildWhenWaiting(),
                  );
                });
          },
          child: _buildWhenNoData(),
        );
      },
    );
  }

  Widget _buildWhenNoData() {
    return Consumer<SearchResponseNotifer>(
      builder: (context, value, child) {
        return value.searchResponse != null
            ? WatchView(
                parser: value.parser, searchResponse: value.searchResponse!)
            : _buildBase(
                selectedResponseText:
                    SelectedResponseText(text: 'Not Found: ${title()}'),
                children: [child!]);
      },
      child: const NotFound(),
    );
  }

  Widget _buildWhenWaiting() {
    return _buildBase(
        selectedResponseText:
            SelectedResponseText(text: 'Searching: ${title()}'),
        children: [const PerfectLoadingIndicator()]);
  }

  Widget _buildWhenDone() {
    return _buildBase(
      selectedResponseText: Consumer<SearchResponseNotifer>(
        builder: (context, value, child) => SelectedResponseText(
            text: 'Selected: ${value.searchResponse!.title}'),
      ),
      children: [
        Consumer<SearchResponseNotifer>(
            builder: (context, searchResponseNotifer, child) => WatchView(
                  parser: searchResponseNotifer.parser,
                  searchResponse: searchResponseNotifer.searchResponse!,
                ))
      ],
    );
  }

  Widget _buildBase({
    required Widget selectedResponseText,
    required List<Widget> children,
  }) {
    return Column(children: [
      addVerticalSpace(30),
      selectedResponseText,
      addVerticalSpace(10),
      _buildSourceDropDown(),
      addVerticalSpace(5),
      _buildWrongTitleButton(),
      addVerticalSpace(40),
      ...children,
    ]);
  }

  Widget _buildSourceDropDown() => SourceDropDown(sources: sources);

  Widget _buildWrongTitleButton() {
    return Builder(builder: (context) {
      return Consumer<SearchResponseNotifer>(
          builder: (context, value, child) => GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      showDragHandle: true,
                      backgroundColor: bestGrey,
                      context: context,
                      builder: (_) => SearchBottomSheet(
                            text: value.searchResponse?.title ??
                                media.name ??
                                media.title,
                            onFutureChanged: (future) =>
                                value.updateFuture(future),
                            onSelected: (response) =>
                                value.changeSearchResponse(response),
                            parser: value.parser,
                            future: value.future,
                            selected: value.searchResponse,
                          ));
                },
                child: Container(
                  height: 16,
                  padding: const EdgeInsets.only(right: 50),
                  alignment: Alignment.centerRight,
                  child: const DefaultTextStyle(
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      child: Text('Wrong Title?')),
                ),
              ));
    });
  }
}
