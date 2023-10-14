import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/resources/providers/meta_provider.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/resources/providers/providers.dart';
import 'package:meiyou/core/resources/providers/tmdb_provider.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/anime_pahe.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/aniwave.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/gogo.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/aniwatch.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/flixhq.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/look_movie.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/press_play.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/sflix.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/yomovies.dart';
import 'package:meiyou/data/data_source/providers/tmdb_providers/smashy_stream.dart';
import 'package:meiyou/data/data_source/providers/tmdb_providers/susflix.dart';

class MetaProviders extends Providers {
  @override
  Map<String, MetaProvider> get providers => {
        'Anilist': Anilist(),
        'TMDB': TMDB(),
      };
}

class MovieProviders extends Providers {
  @override
  Map<String, MovieProvider> get providers => {
        'PressPlay': PressPlay(),
        'LookMovie': LookMovie(),
        // 'Rewatch': Rewatch(),
        'FlixHQ': Flixhq(),
        'Sflix': Sflix(),
        'YoMovies': YoMovies(),
      };
}

class AnimeProviders extends Providers {
  @override
  Map<String, AnimeProvider> get providers => {
        'Gogo': Gogo(),
        'Aniwave': Aniwave(),
        'Animepahe': AnimePahe(),
        'AniWatch': AniWatch(),
      };
}

class TMDBProviders extends Providers {
  @override
  Map<String, TMDBProvider> get providers => {
        'SmashyStream': SmashyStream(),
        'Susflix': Susflix(),
      };
}
