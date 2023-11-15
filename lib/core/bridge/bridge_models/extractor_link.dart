import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:meiyou/core/constants/bridge_libary.dart';
import 'package:meiyou/data/models/extractor_link.dart';


class $ExtractorLink implements ExtractorLink, $Instance {
  $ExtractorLink.wrap(this.$value);

  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(bridgeLibary, 'ExtractorLink.', $new);
  }

  static const $type =
      BridgeTypeRef(BridgeTypeSpec(bridgeLibary, 'ExtractorLink'));

  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(returns: BridgeTypeAnnotation($type), namedParams: [
          // required this.url, this.posterImage, this.description
          BridgeParameter(
              'name',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string),
              ),
              true),
          BridgeParameter(
              'url',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string),
              ),
              true),
          BridgeParameter(
              'headers',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map),
                  nullable: true),
              true),
          BridgeParameter(
              'referer',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                  nullable: true),
              true),

          BridgeParameter(
              'extra',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map),
                  nullable: true),
              true),
        ]),
      )
    },
    fields: {
      'name': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.string),
        ),
      ),
      'url': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.string),
        ),
      ),
      'headers': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map), nullable: true),
      ),
      'referer': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string), nullable: true),
      ),
      'extra': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map), nullable: true),
      ),
    },
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $ExtractorLink.wrap(
      ExtractorLink(
          name: args[0]?.$value ?? '',
          url: args[1]?.$value ?? '',
          headers: (args[2]?.$value as Map?)?.map((key, value) => MapEntry(
              (key is $Value) ? key.$value : key,
              (value is $Value) ? value.$value : value)),
          referer: args[3]?.$value,
          extra: (args[4]?.$value as Map?)?.map((key, value) => MapEntry(
              (key is $Value) ? key.$value : key,
              (value is $Value) ? value.$value : value))),
    );
  }

  @override
  Map<String, String>? get headers => $value.headers;

  @override
  String get name => $value.name;

  @override
  String? get referer => $value.referer;

  @override
  String get url => $value.url;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'name':
        return $String(name);
      case 'url':
        return $String(url);
      case 'referer':
        return referer != null ? $String(referer!) : $null();
      case 'headers':
        return headers != null
            ? $Map.wrap(headers!
                .map((key, value) => MapEntry($String(key), $String(value))))
            : $null();
      case 'extra':
        return extra != null
            ? $Map
                .wrap(extra!.map((key, value) => MapEntry($String(key), value)))
            : $null();
      default:
        return null;
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    // switch (identifier) {
    //   case 'name':
    //     $value.name = value.$reified;
    //   case 'url':
    //     $value.name = value.$reified;
    //   case 'referer':
    //     $value.referer = value.$reified;
    //   case 'headers':
    //     $value.headers = (value.$reified as Map<$Value, $Value>?)
    //         ?.map((key, value) => MapEntry(key.$value, value.$value));
    //   case 'extra':
    //     $value.headers = (value.$reified as Map<$Value, dynamic>?)
    //         ?.map((key, value) => MapEntry(key.$value, value));

    //   default:
    //     null;
    // }
  }

  @override
  get $reified => $value;

  @override
  final ExtractorLink $value;

  @override
  Map<String, dynamic>? get extra => $value.extra;

  @override
  set headers(Map<String, String>? _headers) {
    // TODO: implement headers
  }

  @override
  set name(String _name) {
    // TODO: implement name
  }

  @override
  set referer(String? _referer) {
    // TODO: implement referer
  }

  @override
  set url(String _url) {
    // TODO: implement url
  }

  @override
  set extra(Map<String, dynamic>? _extra) {
    // TODO: implement extra
  }
}
