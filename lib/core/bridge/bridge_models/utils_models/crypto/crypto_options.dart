import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:meiyou/core/constants/bridge_libary.dart';
import 'package:meiyou/data/models/utils_models/crypto/crypto_options.dart';


class $CryptoOptions implements $Instance, CryptoOptions {
  $CryptoOptions.wrap(this.$value) : _superclass = $Object($value);

  late final $Instance _superclass;

  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(bridgeLibary, 'CryptoOptions.', $new);
  }

  static const $type =
      BridgeTypeRef(BridgeTypeSpec(bridgeLibary, 'CryptoOptions'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
          BridgeFunctionDef(returns: BridgeTypeAnnotation($type), namedParams: [
            BridgeParameter(
                'textEncoding',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'keyEncoding',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'ivEncoding',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'salt',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'saltEncoding',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'mode',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'padding',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
            BridgeParameter(
                'encoding',
                BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                true),
          ]),
        )
      },
      fields: {
        'textEncoding': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'keyEncoding': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'ivEncoding': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'salt': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'saltEncoding': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'mode': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'padding': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
        'encoding': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.string),
            nullable: true)),
      },
      wrap: true);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'ivEncoding':
        return $value.ivEncoding == null
            ? $null()
            : $String($value.ivEncoding!);

      case 'keyEncoding':
        return $value.keyEncoding == null
            ? $null()
            : $String($value.keyEncoding!);

      case 'salt':
        return $value.salt == null ? $null() : $String($value.salt!);

      case 'saltEncoding':
        return $value.saltEncoding == null
            ? $null()
            : $String($value.saltEncoding!);

      case 'textEncoding':
        return $value.textEncoding == null
            ? $null()
            : $String($value.textEncoding!);

      case 'mode':
        return $value.mode == null ? $null() : $String($value.mode!);

      case 'padding':
        return $value.padding == null ? $null() : $String($value.padding!);

      case 'encoding':
        return $value.encoding == null ? $null() : $String($value.encoding!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CryptoOptions.wrap(CryptoOptions(
      textEncoding: args[0]?.$value,
      keyEncoding: args[1]?.$value,
      ivEncoding: args[2]?.$value,
      salt: args[3]?.$value,
      saltEncoding: args[4]?.$value,
      mode: args[5]?.$value,
      padding: args[6]?.$value,
      encoding: args[7]?.$value,
    ));
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  CryptoOptions get $reified => $value;

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    _superclass.$setProperty(runtime, identifier, value);
  }

  @override
  final CryptoOptions $value;

  @override
  String? get ivEncoding => $value.ivEncoding;

  @override
  String? get keyEncoding => $value.keyEncoding;

  @override
  String? get salt => $value.salt;

  @override
  String? get saltEncoding => $value.saltEncoding;

  @override
  String? get textEncoding => $value.textEncoding;

  @override
  String? get mode => $value.mode;

  @override
  String? get padding => $value.padding;

  @override
  String? get encoding => $value.encoding;
}