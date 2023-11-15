import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';

import 'package:meiyou/core/constants/bridge_libary.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/subtitle_format.dart';
import 'package:meiyou/data/models/media/video/subtitle.dart';
import 'package:meiyou/data/models/media/video/subtitle_format.dart';


class $Subtitle implements Subtitle, $Instance {
  $Subtitle.wrap(this.$value);

  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(bridgeLibary, 'Subtitle.', $Subtitle.$new);
  }

  static const $type = BridgeTypeRef(BridgeTypeSpec(bridgeLibary, 'Subtitle'));

  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(returns: BridgeTypeAnnotation($type), namedParams: [
          BridgeParameter(
              'url',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string),
              ),
              false),
          BridgeParameter(
              'format',
              BridgeTypeAnnotation($SubtitleFormat.$type, nullable: true),
              true),
          BridgeParameter(
              'langauge',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                  nullable: true),
              true),
          BridgeParameter(
              'headers',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map),
                  nullable: true),
              true),
        ]),
      )
    },
    fields: {
      'url': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.string),
        ),
      ),
      'format': BridgeFieldDef(
        BridgeTypeAnnotation($SubtitleFormat.$type, nullable: true),
      ),
      'langauge': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string), nullable: true),
      ),
      'headers': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map), nullable: true),
      ),
    },
    wrap: true,
  );

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'url':
        return $String($value.url);
      case 'format':
        return $value.format != null
            ? $SubtitleFormat.wrap($value.format!)
            : $null();

      case 'langauge':
        return $value.langauge != null ? $String($value.langauge!) : $null();
      case 'headers':
        return $value.headers != null
            ? $Map.wrap($value.headers!
                .map((key, value) => MapEntry($String(key), $String(value))))
            : $null();

      default:
        return $null();
    }
  }

  static $Value $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $Subtitle.wrap(Subtitle(
      url: args[0]?.$value ?? '',
      format: args[1]?.$value,
      langauge: args[2]?.$value,
      headers: (args[3]?.$value as Map?)?.map((key, value) => MapEntry(
          (key is $Value) ? key.$value : key,
          (value is $Value) ? value.$value : value)),
    ));
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  get $reified => $value;

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {}

  @override
  final Subtitle $value;

  @override
  SubtitleFormat? get format => $value.format;

  @override
  Map<String, String>? get headers => $value.headers;

  @override
  String? get langauge => $value.langauge;

  @override
  String get url => $value.url;
}
