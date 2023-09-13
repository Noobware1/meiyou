import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/element.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/extractors/rewatch.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/dom.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class Rewatch extends MovieProvider {
  @override
  String get name => 'Rewatch';

  @override
  String get hostUrl => 'https://rewatch.to';

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    final urlAndReferer = url.split('referer=');
    return [
      VideoServer(
          url: urlAndReferer[0],
          name: 'ReWatch [Main]',
          extra: {'referer': urlAndReferer[1]})
    ];
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    return List.from(jsonDecode(url)).mapAsList((it) => _episodesFromJson(it));
  }

  @override
  Future<Movie> loadMovie(String url) => client.get(url).then((response) {
        final doc = response.document;
        final token = _getToken(doc);
        return Movie(
            url:
                '${_generateUrl(doc.selectFirst('#video_key').attr('value'), token)}referer=$url');
      });

  String _getToken(Document doc) {
    return doc.selectFirst('meta#_token').attr('value');
  }

  String _generateUrl(String id, String token) {
    return '$hostUrl/fetch/$id?_token=$token';
  }

  Episode _episodesFromJson(dynamic json) {
    return Episode(
        number: json['number'] as num,
        url: '${json["url"]}referer=${json["referer"]}',
        title: json['title'] as String);
  }

  @override
  Future<List<Season>> loadSeasons(String url) {
    return client.get(url).then((response) {
      final doc = response.document;
      final token = _getToken(doc);
      final seasons = doc
          .select('.dropdown-menu-left > button')
          .mapAsList((it) => it.attr('id').replaceFirst('S', ''));

      final episodes =
          doc.select('.dropdown.episodes > div > button').mapAsList((it) {
        return jsonEncode({
          'number': it.attr('id').replaceFirst('E', '').toNum(),
          'url': _generateUrl(it.attr("data-key"), token),
          'title': it.text,
          'referer': url
        });
      });

      return List.generate(
          seasons.length,
          (index) =>
              Season(number: seasons[index].toNum(), url: episodes[index]));
    });
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return ReWatch(videoServer);
  }

  @override
  Future<List<SearchResponse>> search(String query) =>
      client.get("$hostUrl/search?query=${encode(query)}").then((response) {
        return response.document
            .select('div.row.row-cols-6.pt-2 > div.col > .list-item')
            .mapAsList((it) {
          final element = it.selectFirst('a');
          final title = it.selectFirst('div.list-caption > .list-title').text;

          final url = hostUrl + element.href;
          final cover = hostUrl +
              element.selectFirst('.media.media-cover').getBackgroundImage();
          return SearchResponse(
              title: title,
              url: url,
              cover: cover,
              type: url.contains('movie') ? MediaType.movie : MediaType.tvShow);
        });
      });
}
