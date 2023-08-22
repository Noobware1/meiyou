import 'package:html/dom.dart';
import 'package:ok_http_dart/ok_http_dart.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/utils.dart';
import 'package:streamify/providers/extractors/xmovie_extractor.dart';
import 'package:streamify/providers/movie_providers/base_movie_source_parser.dart';

class XMovies extends MovieSource {
  @override
  // TODO: implement name
  String get name => 'Xmovies';

  @override
  // TODO: implement hostUrl
  String get hostUrl => '';

 
  @override
  Future<List<SearchResponse>?> search(String query) async {
    final doc = (await client.get(
            'https://xemovie.net/search?_token=yb6sVvRDTFQq7otRZZaKpS1Ae67Wo5uobNxXYzXT&q=${encode(query, "+")}'))
        .document;

    final row = doc.select('div.stars.col-4.col-lg-3.col-xxl-2');

    return row.map((e) {
      final url = e.selectFirst('a').attr('href');
      final type =
          url.contains('/movies/') ? MediaType.movie : MediaType.tvShow;
      return SearchResponse(
          title: e.selectFirst('.star-name > div').text,
          cover: e.selectFirst('a > img').attr('src'),
          url: url,
          type: type);
    }).toList();
  }

 Future<LoadResponse?> load(
      {required SearchResponse data,
      List<Season>? seasons,
      Season? season}) async {
    //print(data.title);
    final LoadResponse? response;
    if (data.type == MediaType.movie) {
      final movie = await loadMovie(data.url);

      response = movie != null ? LoadResponse.fromMovie(movie: movie) : null;
    } else {
      final List<Episode>? episode;
      if (seasons == null) {
        final allSeasons = await loadSeasons(data.url);
        if (allSeasons == null || allSeasons.isEmpty) {
          episode = await loadEpisodes(data.url);
          response = (episode != null)
              ? LoadResponse.fromTvResponse(episodes: episode, seasons: seasons)
              : null;
        } else {
          episode = await loadEpisodes(
              allSeasons[season!.number.toInt() - 1].seasonUrl);
          response = (episode != null)
              ? LoadResponse.fromTvResponse(
                  episodes: episode, seasons: allSeasons)
              : null;
        }
      } else {
        episode =
            await loadEpisodes(seasons[season!.number.toInt() - 1].seasonUrl);
        response = (episode != null)
            ? LoadResponse.fromTvResponse(episodes: episode, seasons: seasons)
            : null;
      }
    }

    return response;
  }

  @override
  Future<List<Episode>?> loadEpisodes(String url) async {
    final doc = (await client.get(url)).document;
    final episodes = doc
        .select('.bg-detail.row.text-center.ep-list > div > a')
        .map((e) => Episode(
            number: e.text.substringAfter('episode'),
            url: e.attr('href')))
        .toList();

    return episodes;
  }

  @override
  Future<Movie?> loadMovie(String url) async {
    final doc = (await client.get(url)).document;

    return Movie(url: _getUrl(doc));
  }

  @override
  Future<List<Season>?> loadSeasons(String url) async {
    if (url.contains('/movies/')) {
      return null;
    }
    final doc = (await client.get(url)).document;

    const seasonsSelector =
        'div.season-list.owl-carousel.owl-carousel2.owl-theme.bg-detail > div.season-item';
    if (!doc.isPresent(seasonsSelector)) {
      final seasonUrl = _getUrl(doc);
      return [Season(number: '1', seasonUrl: seasonUrl)];
    }
    final seasons = doc.select(seasonsSelector);
    return List.generate(seasons.length, (i) {
      return Season(
          number: RegExp(r'\d+')
                  .firstMatch(seasons[i].selectFirst('a > .no-wrap').text)
                  ?.group(0) ??
              (i + 1).toString(),
          seasonUrl: seasons[i].selectFirst('a').attr('href'));
    });

    //return seasons;
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) {
    return Future.value([VideoServer(name: 'Main Source', serverUrl: url)]);
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer server) {
    return XMoviesExtractor(server);
  }

  String _getUrl(Document doc) {
    return doc.selectFirst('div.row.text-center.d-block > a').attr('href');
  }
}
