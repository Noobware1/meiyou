import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/resources/providers/meta_provider.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/resources/providers/providers.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/anime_pahe.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/gogo.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/zoro.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/flixhq.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/press_play.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/rewatch.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/sflix.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/mock_movie_provider.dart';


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
       'MockProvider': MockMovieProvider(),
        // 'FlixHQ': Flixhq(),
        // 'Sflix': Sflix(),
        // 'Rewatch': Rewatch(),
        // 'PressPlay': PressPlay()
      };
}

class AnimeProviders extends Providers {
  @override
  Map<String, AnimeProvider> get providers => {
        'Gogo': Gogo(),
        'Animepahe': AnimePahe(),
        'AniWatch': Zoro(),
      };
}
