import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/utils.dart';
import 'package:streamify/notifers/search_response_notifer.dart';
import 'package:streamify/notifers/watch_notifer.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/widgets/not_found.dart';
import 'package:streamify/widgets/perfect_loading_indicator.dart';
import 'package:streamify/providers/base_parser.dart';
import 'package:streamify/widgets/watch/episode_view.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/providers/providers.dart';
import 'package:streamify/utils/check_connection_state.dart';
import 'package:streamify/widgets/watch/movie_view.dart';
import 'package:streamify/widgets/watch/season_selector.dart';

class WatchView extends StatefulWidget {
  final BaseParser parser;
  final SearchResponse searchResponse;

  const WatchView(
      {super.key, required this.parser, required this.searchResponse});

  @override
  State<WatchView> createState() => _WatchViewState();
}

class _WatchViewState extends State<WatchView> {
  late SearchResponse searchResponse;
  late final MediaDetails media;
  Future<List<Season>?>? seasons;
  // Future<LoadResponse?>? loadResponse;

  void initSeasons() {
    if (media.mediaType == MediaType.tvShow) {
      seasons = providers.getSeasons(
          data: media,
          provider: widget.parser,
          searchResponse: widget.searchResponse);
    }
  }

  @override
  void initState() {
    searchResponse = widget.searchResponse;
    media = Provider.of<MediaDetails>(context, listen: false);
    // initSeasons();
    initSeasons(); // getLoadResponse(null, null);
    // init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchResponseNotifer>(
      builder: (context, value, child) {
        print('2');
        return FutureBuilder(
          future: providers.getSeasons(
              provider: value.parser,
              searchResponse: value.searchResponse!,
              data: media),
          builder: (context, snapshot) {
            if (waiting(snapshot)) {
              return child!;
            } else if (done(snapshot)) {
              return _buildMain(snapshot.data!);
            } else {
              return _buildMain(null);
            }
          },
        );
      },
      child: const PerfectLoadingIndicator(),
    );
  }

  Widget _buildMain(List<Season>? seasons) {
    return ChangeNotifierProxyProvider<SearchResponseNotifer, WatchViewNotifer>(
        update: (context, value, pre) => WatchViewNotifer(
            seasons: seasons,
            futureLoadResponse: providers.invokeProvider(
                provider: widget.parser,
                searchResponse: value.searchResponse!,
                data: media,
                seasons: seasons),
            baseParser: widget.parser,
            media: media,
            searchResponse: value.searchResponse!),
        create: (context) => WatchViewNotifer(
            seasons: seasons,
            futureLoadResponse: providers.invokeProvider(
                provider: widget.parser,
                searchResponse: searchResponse,
                data: media,
                seasons: seasons),
            baseParser: widget.parser,
            media: media,
            searchResponse: searchResponse),
        builder: (context, child) => Consumer<WatchViewNotifer>(
              builder: (context, value, child) {
                print('3');
                return FutureBuilder(
                    future: value.futureLoadResponse,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          if (seasons != null && snapshot.data != null)
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: SeasonSelector()),
                            ),
                          if (seasons != null && snapshot.data != null)
                            addVerticalSpace(10),
                          if (waiting(snapshot))
                            const SizedBox(
                                height: 300,
                                child: Center(child: PerfectLoadingIndicator()))
                          else if (done(snapshot))
                            widget.searchResponse.type == MediaType.movie
                                ? MovieView(loadResponse: snapshot.data!)
                                : EpisodeView(loadResponse: snapshot.data!)
                          else
                            const NotFound()
                        ],
                      );
                    });
              },
            ));
  }
}

// class LoadSeasonsWidget extends StatefulWidget {
//   const LoadSeasonsWidget({super.key});

//   @override
//   State<LoadSeasonsWidget> createState() => _LoadSeasonsWidgetState();
// }

// class _LoadSeasonsWidgetState extends State<LoadSeasonsWidget> {
//   Future<List<Season>?>? seasons;
//   late final SearchResponseNotifer notifer;
//   late final MediaDetails media;

//   @override
//   void initState() {
//     media = Provider.of<MediaDetails>(context, listen: false);
//     notifer = Provider.of<SearchResponseNotifer>(context, listen: false);
//     // seasons = providers.getSeasons(
//     //     provider: notifer.parser,
//     //     searchResponse: notifer.searchResponse!,
//     //     data: media);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(builder: (context, snapshot) {
//       if(waiting(snapshot)) {
//         return PerfectLoadingIndicator();

//       } else if(done(snapshot)) {
//         return ChangeNotifierProvider(create: create)
//       }
//     } )
//   }
// }

class SeasonNotifer extends ChangeNotifier {
  Future<List<Season>?>? seasons;
  final MediaDetails media;

  SeasonNotifer({required this.media});

  void update(BaseParser parser, SearchResponse response) {
    seasons = providers.getSeasons(
        provider: parser, searchResponse: response, data: media);
    notifyListeners();
  }
}
