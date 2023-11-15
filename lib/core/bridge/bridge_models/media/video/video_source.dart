import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';

import 'package:meiyou/core/constants/bridge_libary.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video_format.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/video_quailty.dart';
import 'package:meiyou/data/models/media/video/video_format.dart';
import 'package:meiyou/data/models/media/video/video_quailty.dart';
import 'package:meiyou/data/models/media/video/video_source.dart';

class $VideoSource implements VideoSource, $Instance {
  $VideoSource.wrap(this.$value);

  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(bridgeLibary, 'VideoSource.', $VideoSource.$new);
  }

  static const $type =
      BridgeTypeRef(BridgeTypeSpec(bridgeLibary, 'VideoSource'));

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
              true),
          BridgeParameter('format',
              BridgeTypeAnnotation($VideoFormat.$type, nullable: false), true),
          BridgeParameter('quality',
              BridgeTypeAnnotation($VideoQuality.$type, nullable: true), true),
          BridgeParameter(
              'title',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                  nullable: true),
              true),
          BridgeParameter(
              'isBackup',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool),
                  nullable: false),
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
      'quality': BridgeFieldDef(
        BridgeTypeAnnotation($VideoQuality.$type, nullable: true),
      ),
      'format': BridgeFieldDef(
        BridgeTypeAnnotation($VideoFormat.$type, nullable: false),
      ),
      'title': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string), nullable: true),
      ),
      'isBackup': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool), nullable: false),
      ),
    },
    wrap: true,
  );

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'url':
        return $String($value.url);
      case 'quality':
        return $value.quality != null
            ? $VideoQuality.wrap($value.quality!)
            : const $null();
      case 'format':
        return $VideoFormat.wrap($value.format);
      case 'title':
        return $value.title != null ? $String($value.title!) : const $null();

      default:
        return const $null();
    }
  }

  static $Value $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $VideoSource.wrap(VideoSource(
      url: args[0]?.$value ?? '',
      format: args[1]?.$value ?? VideoFormat.other,
      quality: args[2]?.$value,
      title: args[3]?.$value,
      isBackup: args[4]?.$value ?? false,
    ));
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  get $reified => $value;

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'url':
        $value.url = value.$reified;
      case 'quality':
        $value.quality = value.$reified;
      case 'format':
        $value.format = value.$reified;
      case 'title':
        $value.title = value.$reified;
    }
  }

  @override
  final VideoSource $value;

  @override
  VideoFormat get format => $value.format;

  @override
  bool get isBackup => $value.isBackup;

  @override
  VideoQuality? get quality => $value.quality;

  @override
  String? get title => $value.title;

  @override
  String get url => $value.url;

  @override
  set format(VideoFormat _format) {
    // TODO: implement format
  }

  @override
  set quality(VideoQuality? _quality) {
    // TODO: implement quality
  }

  @override
  set title(String? _title) {
    // TODO: implement title
  }

  @override
  set url(String _url) {
    // TODO: implement url
  }

  @override
  set isBackup(bool _isBackup) {
    // TODO: implement isBackup
  }
}
