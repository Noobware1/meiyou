import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

typedef BuildWhen<S> = bool Function(S previous, S current);

typedef ListenWhen<S> = bool Function(S previous, S current);

typedef BuildWithState<S> = Widget Function(BuildContext context, S state);

typedef StateListener<S> = void Function(BuildContext context, S state);

class GetItConsumer<B extends StateNotifer<S>, S> extends StatelessWidget {
  final ListenWhen<S>? listenWhen;
  final BuildWhen<S>? buildWhen;
  final BuildWithState<S> builder;
  final StateListener<S> listener;
  final B? notifer;
  const GetItConsumer({
    Key? key,
    this.listenWhen,
    this.buildWhen,
    required this.builder,
    required this.listener,
    this.notifer,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return GetItListenableBuilder<B, S>(
      notifer: notifer,
      buildWhen: (prev, curr) {
        if (listenWhen?.call(prev, curr) ?? true) {
          listener(context, curr);
        }
        return buildWhen?.call(prev, curr) ?? true;
      },
      builder: builder,
    );
  }
}

class GetItListenableBuilder<B extends StateNotifer<S>, S>
    extends _GetItListenableBuilderBase<B, S> {
  final BuildWithState<S> builder;
  const GetItListenableBuilder({
    Key? key,
    BuildWhen<S>? buildWhen,
    required this.builder,
    B? notifer,
  }) : super(
          key: key,
          notifer: notifer,
          listenWhen: buildWhen,
        );

  @override
  Widget build(BuildContext context, S state) {
    return builder(context, state);
  }
}

abstract class _GetItListenableBuilderBase<B extends StateNotifer<S>, S>
    extends StatefulWidget {
  /// {@macro Notifer_builder_base}
  const _GetItListenableBuilderBase({Key? key, this.notifer, this.listenWhen})
      : super(key: key);

  /// The [notifer] that the [_GetItListenableBuilderBase] will interact with.
  /// If omitted, [_GetItListenableBuilderBase] will automatically perform a lookup using
  /// [NotiferProvider] and the current `BuildContext`.
  final B? notifer;

  /// {@macro Notifer_builder_build_when}
  final ListenWhen<S>? listenWhen;

  Widget build(BuildContext context, S state);

  @override
  State<_GetItListenableBuilderBase<B, S>> createState() =>
      _GetItListenableBuilderState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<ListenWhen<S>?>.has(
          'listenWhen',
          listenWhen,
        ),
      )
      ..add(DiagnosticsProperty<B?>('notifer', notifer));
  }
}

class _GetItListenableBuilderState<B extends StateNotifer<S>, S>
    extends State<_GetItListenableBuilderBase<B, S>> {
  late B _notifer;
  late S _state;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _notifer = widget.notifer ?? getIt.get<B>();
    _state = _notifer.state;
    _notifer.addListener(listener);
  }

  void listener() {
    if (widget.listenWhen?.call(_state, _notifer.state) ?? true) {
      setState(() {
        _state = _notifer.state;
      });
    }
  }

  @override
  void didUpdateWidget(_GetItListenableBuilderBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldNotifer = oldWidget.notifer ?? getIt.get<B>();
    final currentNotifer = widget.notifer ?? oldNotifer;
    if (oldNotifer != currentNotifer) {
      _notifer = currentNotifer;
      _state = _notifer.state;
      oldNotifer.removeListener(listener);
    }
    currentNotifer.addListener(listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifer = widget.notifer ?? getIt.get<B>();
    if (_notifer != notifer) {
      _notifer = notifer;
      _state = _notifer.state;
      _notifer.removeListener(listener);
    }
    _notifer.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _state);
  }
}

abstract class InjecktorWidget extends StatelessWidget {
  const InjecktorWidget({super.key});

  @override
  Widget build(BuildContext context);

  void addSingleton<S extends Object>(
    BuildContext context,
    S Function() builder, {
    String? name,
  }) {
    return _add<S>(context, builder, name: name, lazy: false);
  }

  void lazyAddSingleton<S extends Object>(
    BuildContext context,
    S Function() builder, {
    String? name,
  }) {
    return _add<S>(context, builder, name: name, lazy: true);
  }

  void addFactory<S extends Object>(
    BuildContext context,
    S Function() builder, {
    String? name,
  }) {
    return _add<S>(context, builder, name: name, lazy: false, isFactory: true);
  }

  void _add<S extends Object>(
    BuildContext context,
    S Function() builder, {
    String? name,
    required bool lazy,
    bool isFactory = false,
  }) {
    final key = name == null ? S.toString() : S.toString() + name;
    context as GetItElement;

    if (!context._names.contains(key) &&
        !getIt.isRegistered<S>(instanceName: name)) {
      if (isFactory) {
        getIt.registerFactory<S>(builder, instanceName: name);
      } else {
        if (lazy) {
          getIt.registerLazySingleton<S>(builder, instanceName: name);
        } else {
          getIt.registerSingleton<S>(builder(), instanceName: name);
        }
      }
      context._addName(key);
    }
  }

  @override
  StatelessElement createElement() => GetItElement(this);
}

class GetItElement extends StatelessElement {
  GetItElement(InjecktorWidget widget) : super(widget);

  static final List<String?> _emptyNames = List<String?>.filled(0, null);
  List<String?> _names = _emptyNames;

  int _count = 0;

  void _addName(String name) {
    if (_count == _names.length) {
      if (_count == 0) {
        _names = List<String?>.filled(1, null);
      } else {
        final List<String?> newNames =
            List<String?>.filled(_names.length * 2, null);
        for (int i = 0; i < _count; i++) {
          newNames[i] = _names[i];
        }
        _names = newNames;
      }
    }
    _names[_count++] = name;
  }

  void _dispose() {
    for (int i = 0; i < _count; i++) {
      getIt.unregister(instanceName: _names[i]);
    }
    _count = 0;
    _names = _emptyNames;
  }

  @override
  void unmount() {
    super.unmount();
    _dispose();
  }
}
