import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:meiyou/core/constants/bridge_libary.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/unwrap.dart';
import 'package:meiyou/core/bridge/bridge_models/document.dart';
import 'package:meiyou/core/bridge/bridge_models/element.dart';
import 'package:meiyou/core/bridge/bridge_models/media/video/subtitle_format.dart';
import 'package:meiyou/core/bridge/bridge_models/ok_http_response.dart';
import 'package:meiyou/data/models/element.dart';
import 'package:meiyou/data/models/meiyou_utils.dart';



class $MeiyouUtils extends MeiyouUtils with $Bridge<MeiyouUtils> {
  static const $type =
      BridgeTypeRef(BridgeTypeSpec(bridgeLibary, 'MeiyouUtils'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type), namedParams: [], params: []))
      },
      methods: {
        'httpRequest': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(
                    CoreTypes.future, [$OkHttpResponseObject.$type])),
                namedParams: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                  BridgeParameter(
                      'method',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'followRedircts',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'cookie',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'referer',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'params',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map),
                          nullable: true),
                      true),
                  BridgeParameter(
                      'body',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.object),
                          nullable: true),
                      true),
                ]),
            isStatic: true),
        'encode': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                params: [
                  BridgeParameter(
                      'query',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                  BridgeParameter(
                      'replaceWith',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      true),
                ],
                namedParams: []),
            isStatic: true),
        'toDateTime': BridgeMethodDef(
            BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dateTime)),
              params: [
                BridgeParameter('year',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
              ],
              namedParams: [
                BridgeParameter(
                    'month',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
                BridgeParameter(
                    'day',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
                BridgeParameter(
                    'hour',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
                BridgeParameter(
                    'minute',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
                BridgeParameter(
                    'second',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
                BridgeParameter(
                    'millisecond',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
                BridgeParameter(
                    'microsecond',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int),
                        nullable: true),
                    true),
              ],
            ),
            isStatic: true),
        'parseHtml': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation($DocumentObject.$type),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'selectMultiAttr': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(
                    CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                params: [
                  BridgeParameter(
                      'elements',
                      BridgeTypeAnnotation(BridgeTypeRef(
                          CoreTypes.list, [$ElementObject.$type])),
                      false),
                  BridgeParameter(
                      'attr',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'selectMultiText': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(
                    CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                params: [
                  BridgeParameter(
                      'elements',
                      BridgeTypeAnnotation(BridgeTypeRef(
                          CoreTypes.list, [$ElementObject.$type])),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'httpify': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getHost': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getMonthByName': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
                params: [
                  BridgeParameter(
                      'name',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'regexFirstMatch': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string),
                    nullable: true),
                params: [
                  BridgeParameter(
                      'regExp',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.regExp)),
                      false),
                  BridgeParameter(
                      'input',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                      false),
                  BridgeParameter(
                      'group',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getSubtitleFromatFromUrl': BridgeMethodDef(
          BridgeFunctionDef(
              returns:
                  BridgeTypeAnnotation($SubtitleFormat.$type, nullable: true),
              params: [
                BridgeParameter(
                    'url',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
                    false)
              ]),
          isStatic: true,
        ),
        'isNotNull': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
              params: [
                BridgeParameter(
                    'value',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                    false)
              ]),
          isStatic: true,
        ),
        'evalAndStatements': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
              params: [
                BridgeParameter('statements',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list)), false)
              ]),
          isStatic: true,
        ),
        'evalOrStatements': BridgeMethodDef(
          BridgeFunctionDef(
              returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)),
              params: [
                BridgeParameter('statements',
                    BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list)), false)
              ]),
          isStatic: true,
        ),
        // 'tryWithAsync': BridgeMethodDef(
        //     BridgeFunctionDef(
        //         returns: BridgeTypeAnnotation(
        //             BridgeTypeRef(CoreTypes.future, [BridgeTypeRef.ref('E')]),
        //             nullable: true),
        //         params: [
        //           BridgeParameter(
        //               'fun',
        //               BridgeTypeAnnotation(BridgeTypeRef(
        //                   CoreTypes.function, [BridgeTypeRef.ref('E')])),
        //               false),
        //         ],
        //         namedParams: []),
        //     isStatic: true),
        // 'tryWithSync': BridgeMethodDef(
        //     BridgeFunctionDef(
        //         returns: BridgeTypeAnnotation(BridgeTypeRef.ref('E'),
        //             nullable: true),
        //         params: [
        //           BridgeParameter('fun',
        //               BridgeTypeAnnotation(BridgeTypeRef.ref('E')), false),
        //         ],
        //         namedParams: []),
        //     isStatic: true),
      },
      fields: {},
      getters: {},
      setters: {},
      bridge: true);

  static $MeiyouUtils $construct(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $MeiyouUtils();
  }

  static $Future $httpRequest(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Future.wrap(MeiyouUtils.httpRequest(
      url: args[0]?.$value,
      method: args[1]?.$value,
      headers: args[2]?.$value != null
          ? unwrapMap<String, String>(args[2]?.$value as Map)
          : null,
      followRedircts: args[3]?.$value,
      cookie: args[4]?.$value,
      referer: args[5]?.$value,
      params: args[6]?.$value != null
          ? unwrapMap<String, dynamic>(args[6]?.$value as Map)
          : null,
      body: args[7]?.$value,
    ).then((value) => $OkHttpResponseObject.wrap(value)));
  }

  static $String $encode(Runtime runtime, $Value? target, List<$Value?> args) {
    if (args[1]?.$value != null) {
      return $String(MeiyouUtils.encode(args[0]?.$value, args[1]?.$value));
    }
    return $String(MeiyouUtils.encode(args[0]?.$value));
  }

  static $DateTime $toDateTime(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $DateTime.wrap(MeiyouUtils.toDateTime(
      args[0]?.$value,
      month: args[1]?.$value,
      day: args[2]?.$value,
      hour: args[3]?.$value,
      minute: args[4]?.$value,
      second: args[5]?.$value,
      millisecond: args[6]?.$value,
      microsecond: args[7]?.$value,
    ));
  }

  static $DocumentObject $parseHtml(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $DocumentObject.wrap(MeiyouUtils.parseHtml(args[0]?.$value));
  }

  static $Value $selectMultiAttr(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(
        MeiyouUtils.selectMultiAttr(args[0]?.$value, args[1]?.$value)
            .mapAsList((it) => $String(it)));
  }

  static $Value $selectMultiText(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MeiyouUtils.selectMultiText((args[0]?.$value as List)
            .mapAsList(
                (it) => (it is $Value ? it.$value : it) as ElementObject))
        .mapAsList((it) => $String(it)));
  }

  static $Value $httpify(Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MeiyouUtils.httpify(args[0]?.$value));
  }

  static $Value $getHost(Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MeiyouUtils.getHost(args[0]?.$value));
  }

  static $Value $getMonthByName(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $int(MeiyouUtils.getMonthByName(args[0]?.$value));
  }

  static $Value $regexFirstMatch(
      Runtime runtime, $Value? target, List<$Value?> args) {
    final result = MeiyouUtils.regexFirstMatch(
        args[0]!.$value, args[1]!.$value, args[2]!.$value);
    return result == null ? const $null() : $String(result);
  }

  static $Value? $getSubtitleFromatFromUrl(
      Runtime runtime, $Value? target, List<$Value?> args) {
    final $result = MeiyouUtils.getSubtitleFromatFromUrl(args[0]?.$value as String);
    return $result == null ? const $null() : $SubtitleFormat.wrap($result);
  }

  static $Value? $isNotNull(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $bool(MeiyouUtils.isNotNull(args[0]?.$value));
  }

  static $Value? $evalAndStatements(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $bool(
        MeiyouUtils.evalAndStatements(unwrapList<bool>(args[0]!.$value)));
  }

  static $Value? $evalOrStatements(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $bool(
        MeiyouUtils.evalOrStatements(unwrapList<bool>(args[0]!.$value)));
  }

  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.', $MeiyouUtils.$construct,
        isBridge: true);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.httpRequest', $MeiyouUtils.$httpRequest);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.encode', $MeiyouUtils.$encode);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.toDateTime', $MeiyouUtils.$toDateTime);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.parseHtml', $MeiyouUtils.$parseHtml);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.selectMultiAttr',
        $MeiyouUtils.$selectMultiAttr);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.selectMultiText',
        $MeiyouUtils.$selectMultiText);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.httpify', $MeiyouUtils.$httpify);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.getHost', $MeiyouUtils.$getHost);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.getMonthByName',
        $MeiyouUtils.$getMonthByName);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.regexFirstMatch',
        $MeiyouUtils.$regexFirstMatch);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.getSubtitleFromatFromUrl',
        $MeiyouUtils.$getSubtitleFromatFromUrl);
    runtime.registerBridgeFunc(
        bridgeLibary, 'MeiyouUtils.isNotNull', $MeiyouUtils.$isNotNull);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.evalAndStatements',
        $MeiyouUtils.$evalAndStatements);
    runtime.registerBridgeFunc(bridgeLibary, 'MeiyouUtils.evalOrStatements',
        $MeiyouUtils.$evalOrStatements);
  }

  @override
  $Value? $bridgeGet(String identifier) {
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(String identifier, $Value value) {}
}
