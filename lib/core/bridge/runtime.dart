import 'dart:typed_data';

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_security.dart';
import 'package:meiyou/core/bridge/bridge_models/home_page.dart';
import 'package:meiyou/core/bridge/bridge_models/interfaces/base_plugin_api.dart';
import 'package:meiyou/core/bridge/bridge_models/interfaces/extractor_api.dart';
import 'package:meiyou/core/bridge/bridge_models/actor_data.dart';
import 'package:meiyou/core/bridge/bridge_models/document.dart';
import 'package:meiyou/core/bridge/bridge_models/element.dart';
import 'package:meiyou/core/bridge/bridge_models/episode.dart';
import 'package:meiyou/core/bridge/bridge_models/extractor_link.dart';
import 'package:meiyou/core/bridge/bridge_models/media/media.dart';
import 'package:meiyou/core/bridge/bridge_models/media/media_type.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/subtitle.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/subtitle_format.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video_format.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video_quailty.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video_source.dart';
import 'package:meiyou/core/bridge/bridge_models/media_details.dart';
import 'package:meiyou/core/bridge/bridge_models/media_item/anime.dart';
import 'package:meiyou/core/bridge/bridge_models/media_item/media_item.dart';
import 'package:meiyou/core/bridge/bridge_models/media_item/movie.dart';
import 'package:meiyou/core/bridge/bridge_models/media_item/tv_series.dart';
import 'package:meiyou/core/bridge/bridge_models/ok_http_response.dart';
import 'package:meiyou/core/bridge/bridge_models/seaosn_list.dart';
import 'package:meiyou/core/bridge/bridge_models/search_response.dart';
import 'package:meiyou/core/bridge/bridge_models/season_data.dart';
import 'package:meiyou/core/bridge/bridge_models/show_status.dart';
import 'package:meiyou/core/bridge/bridge_models/show_type.dart';
import 'package:meiyou/core/bridge/bridge_models/utils.dart';
import 'package:meiyou/core/bridge/bridge_models/utils_models/crypto/crypto_options.dart';
import 'package:meiyou/core/bridge/bridge_models/utils_models/crypto/crypto_utils.dart';
import 'package:meiyou/core/bridge/bridge_models/utils_models/iterable.dart';
import 'package:meiyou/core/bridge/bridge_models/utils_models/list.dart';
import 'package:meiyou/core/bridge/bridge_models/utils_models/num_utils.dart';
import 'package:meiyou/core/bridge/bridge_models/utils_models/string.dart';
import 'package:meiyou/core/plugin/base_plugin_api.dart';

Runtime runtimeEval(Uint8List bytecode) {
  final runtime = Runtime(bytecode.buffer.asByteData());

  runtime.grant(NetworkPermission.any);

  //Enums
  $ShowType.configureForRuntime(runtime);
  $ShowStaus.configureForRuntime(runtime);
  $MediaItemType.configureForRuntime(runtime);
  $MediaType.configureForRuntime(runtime);
  $SubtitleFormat.configureForRuntime(runtime);
  $VideoFormat.configureForRuntime(runtime);

  //HomePage

  $HomePageData.configureForRuntime(runtime);
  $HomePageRequest.configureForRuntime(runtime);
  $HomePage.configureForRuntime(runtime);
  $HomePageList.configureForRuntime(runtime);

  //Extenstions
  $StringUtils.configureForRuntime(runtime);
  $NumUtils.configureForRuntime(runtime);
  $IterableUtils.configureForRuntime(runtime);
  $ListUtils.configureForRuntime(runtime);
  $CryptoOptions.configureForRuntime(runtime);
  $CryptoUtils.configureForRuntime(runtime);

  //OkHttp
  $ElementObject.configureForRuntime(runtime);
  $DocumentObject.configureForRuntime(runtime);
  $OkHttpResponseObject.configureForRuntime(runtime);

  //MediaDetails
  $MediaDetails.configureForRuntime(runtime);
  $SearchResponse.configureForRuntime(runtime);
  $ActorData.configureForRuntime(runtime);
  $SeasonData.configureForRuntime(runtime);
  $Episode.configureForRuntime(runtime);
  $SeasonList.configureForRuntime(runtime);
  $MediaItemEntity.configureForRuntime(runtime);
  $Anime.configureForRuntime(runtime);
  $TvSeries.configureForRuntime(runtime);
  $Movie.configureForRuntime(runtime);
  $ExtractorLink.configureForRuntime(runtime);

  //Media
  $MediaEntity.configureForRuntime(runtime);
  $Subtitle.configureForRuntime(runtime);
  $Video.configureForRuntime(runtime);
  $VideoQuality.configureForRuntime(runtime);
  $VideoSource.configureForRuntime(runtime);
  $Subtitle.configureForRuntime(runtime);

  //App utils
  $MeiyouUtils.configureForRuntime(runtime);

  //Interfaces
  $ExtractorApi.configureForRuntime(runtime);
  $BasePluginApi.configureForRuntime(runtime);

  return runtime;
}

BasePluginApi executeRuntime(Runtime runtime) {
  return runtime.executeLib('package:meiyou/main.dart', 'main')
      as $BasePluginApi;
}
