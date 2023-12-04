import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:meiyou/core/bridge/bridge_models/home_page.dart';
import 'package:meiyou/core/constants/bridge_libary.dart';
import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/unwrap.dart';
import 'package:meiyou/core/bridge/bridge_models/extractor_link.dart';
import 'package:meiyou/core/bridge/bridge_models/media/media.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video.dart';
import 'package:meiyou/core/bridge/bridge_models/media_details.dart';
import 'package:meiyou/core/bridge/bridge_models/search_response.dart';
import 'package:meiyou/data/models/extractor_link.dart';
import 'package:meiyou/data/models/homepage.dart';
import 'package:meiyou/data/models/media/video/video.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/domain/entities/media.dart';

class $BasePluginApi extends BasePluginApi with $Bridge<BasePluginApi> {
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
        bridgeLibary, 'BasePluginApi.', $BasePluginApi.$new,
        isBridge: true);
  }

  static const $type =
      BridgeTypeRef(BridgeTypeSpec(bridgeLibary, 'BasePluginApi'));

  static const $declaration =
      BridgeClassDef(BridgeClassType($type, isAbstract: true),
          constructors: {
            '': BridgeConstructorDef(
              BridgeFunctionDef(
                returns: BridgeTypeAnnotation($type),
                generics: {},
                namedParams: [],
                params: [],
              ),
            )
          },
          methods: {
            'loadHomePage': BridgeMethodDef(
              BridgeFunctionDef(
                  returns: BridgeTypeAnnotation(
                    BridgeTypeRef(CoreTypes.future, [
                      $HomePage.$type,
                    ]),
                  ),
                  params: [
                    BridgeParameter(
                        'page',
                        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
                        false),
                    BridgeParameter('request',
                        BridgeTypeAnnotation($HomePageRequest.$type), false),
                  ]),
            ),
            'search': BridgeMethodDef(
              BridgeFunctionDef(
                  returns: BridgeTypeAnnotation(
                    BridgeTypeRef(CoreTypes.future, [
                      BridgeTypeRef(CoreTypes.list, [$SearchResponse.$type]),
                    ]),
                  ),
                  params: [
                    BridgeParameter(
                        'query',
                        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                        false)
                  ]),
            ),
            'loadMediaDetails': BridgeMethodDef(
              BridgeFunctionDef(
                  returns: BridgeTypeAnnotation(
                    BridgeTypeRef(CoreTypes.future, [$MediaDetails.$type]),
                  ),
                  params: [
                    BridgeParameter('searchResponse',
                        BridgeTypeAnnotation($SearchResponse.$type), false)
                  ]),
            ),
            'loadLinks': BridgeMethodDef(
              BridgeFunctionDef(
                  returns: BridgeTypeAnnotation(
                    BridgeTypeRef(CoreTypes.future, [
                      BridgeTypeRef(CoreTypes.list),
                    ]),
                  ),
                  params: [
                    BridgeParameter(
                        'url',
                        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                        false)
                  ]),
            ),
            'loadMedia': BridgeMethodDef(
              BridgeFunctionDef(
                  returns: BridgeTypeAnnotation(
                      BridgeTypeRef(CoreTypes.future, [$MediaEntity.$type]),
                      nullable: true),
                  params: [
                    BridgeParameter('link',
                        BridgeTypeAnnotation($ExtractorLink.$type), false)
                  ]),
            ),
          },
          getters: {
            'homePage': BridgeMethodDef(
              BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef(CoreTypes.iterable, [$HomePageData.$type])),
              ),
            )
          },
          bridge: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $BasePluginApi();
  }

  static $Future<$HomePage> $loadHomePage(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Future.wrap((target?.$value as BasePluginApi)
        .loadHomePage(args[0]!.$value, args[1]?.$value)
        .then((value) => $HomePage.wrap(value)));
  }

  static $Future<$List<$SearchResponse>> $search(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Future.wrap((target?.$value as BasePluginApi)
        .search(args[0]?.$value)
        .then((value) =>
            $List.wrap(value.mapAsList((it) => $SearchResponse.wrap(it)))));
  }

  static $Future<$MediaDetails> $loadMediaDetails(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Future.wrap((target?.$value as BasePluginApi)
        .loadMediaDetails(args[0]?.$value)
        .then((value) => $MediaDetails.wrap(value)));
  }

  static $Future<$List<$ExtractorLink>> $loadLinks(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Future.wrap((target?.$value as BasePluginApi)
        .loadLinks(args[0]?.$value)
        .then((value) =>
            $List.wrap(value.mapAsList((it) => $ExtractorLink.wrap(it)))));
  }

  static $Future<$Value?> $loadMedia(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Future.wrap((target?.$value as BasePluginApi)
        .loadMedia(args[0]?.$value)
        .then((value) {
      if (value == null) {
        return null;
      }
      if (value is Video) {
        return $Video.wrap(value);
      } else {
        throw Exception('Bad Response');
      }
    }));
  }

  @override
  $Value? $bridgeGet(String identifier) {
    switch (identifier) {
      case 'loadHomePage':
        return const $Function($loadHomePage);
      case 'search':
        return const $Function($search);
      case 'loadMediaDetails':
        return const $Function($loadMediaDetails);
      case 'loadLinks':
        return const $Function($loadLinks);
      case 'loadMedia':
        return const $Function($loadMedia);

      default:
        return null;
    }
  }

  @override
  void $bridgeSet(String identifier, $Value value) {}

  @override
  Future<MediaDetails> loadMediaDetails(SearchResponse searchResponse) async {
    final value = await ($_invoke(
        'loadMediaDetails', [$SearchResponse.wrap(searchResponse)]) as Future);
    if (value is $MediaDetails) {
      return value.$value;
    }
    throw Exception('Bad Response');
  }

  @override
  Future<List<SearchResponse>> search(String query) async {
    final value = await ($_invoke('search', [$String(query)]) as Future);
    try {
      return unwrapList(unwrapValue<List>(value));
    } catch (_) {
      throw Exception('Bad Response');
    }
  }

  @override
  Future<List<ExtractorLink>> loadLinks(String url) async {
    final value = await ($_invoke('loadLinks', [$String(url)]) as Future);

    try {
      return unwrapList(unwrapValue<List>(value));
    } catch (_) {
      throw Exception('Bad Response');
    }
  }

  @override
  Future<MediaEntity?> loadMedia(ExtractorLink link) async {
    final value =
        unwrapValue((await $_invoke('loadMedia', [$ExtractorLink.wrap(link)])));

    if (value == null) return null;
    try {
      return value as MediaEntity;
    } catch (_) {
      throw Exception('Bad Response');
    }
  }

  @override
  Future<HomePage> loadHomePage(int page, HomePageRequest request) async {
    final value = unwrapValue((await $_invoke(
        'loadHomePage', [$int(page), $HomePageRequest.wrap(request)])));
    return unwrapValue<HomePage>(value);
  }

  @override
  Iterable<HomePageData> get homePage =>
      unwrapIterable<HomePageData>($_get('homePage') as Iterable);
}