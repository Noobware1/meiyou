import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';

class InjecktorBlocBuilder<B extends StateStreamable<S>, S>
    extends InjecktorBlocBuilderBase<B, S> {
  const InjecktorBlocBuilder({
    required this.builder,
    Key? key,
    B? bloc,
    BlocBuilderCondition<S>? buildWhen,
  }) : super(key: key, bloc: bloc, buildWhen: buildWhen);

  final BlocWidgetBuilder<S> builder;

  @override
  Widget build(BuildContext context, S state) => builder(context, state);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<BlocWidgetBuilder<S>>.has('builder', builder),
    );
  }
}

class InjecktorBlocListener<B extends StateStreamable<S>, S>
    extends BlocListener<B, S> {
  InjecktorBlocListener({
    Widget? child,
    Key? key,
    B? bloc,
    BlocListenerCondition<S>? listenWhen,
    required BlocWidgetListener<S> listener,
  }) : super(
            key: key,
            bloc: bloc ?? InjectKtor.get<B>(),
            listenWhen: listenWhen,
            listener: listener,
            child: child);
}

abstract class InjecktorBlocBuilderBase<B extends StateStreamable<S>, S>
    extends StatefulWidget {
  /// {@macro bloc_builder_base}
  const InjecktorBlocBuilderBase({Key? key, this.bloc, this.buildWhen})
      : super(key: key);

  /// The [bloc] that the [InjecktorBlocBuilderBase] will interact with.
  /// If omitted, [InjecktorBlocBuilderBase] will automatically perform a lookup using
  /// [BlocProvider] and the current `BuildContext`.
  final B? bloc;

  /// {@macro bloc_builder_build_when}
  final BlocBuilderCondition<S>? buildWhen;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, S state);

  @override
  State<InjecktorBlocBuilderBase<B, S>> createState() =>
      _BlocBuilderBaseState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<BlocBuilderCondition<S>?>.has(
          'buildWhen',
          buildWhen,
        ),
      )
      ..add(DiagnosticsProperty<B?>('bloc', bloc));
  }
}

class _BlocBuilderBaseState<B extends StateStreamable<S>, S>
    extends State<InjecktorBlocBuilderBase<B, S>> {
  late B _bloc;
  late S _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? InjectKtor.get<B>();
    _state = _bloc.state;
  }

  @override
  void didUpdateWidget(InjecktorBlocBuilderBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? InjectKtor.get<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = _bloc.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? InjectKtor.get<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _state = _bloc.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      InjectKtor.get<B>();
    }
    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _state),
    );
  }
}

abstract class InjecktorWidget extends StatelessWidget {
  const InjecktorWidget({super.key});

  @override
  Widget build(BuildContext context);

  void addSingleton<S>(
    BuildContext context,
    S Function() builder, {
    String? name,
    bool permanent = false,
  }) {
    return _add<S>(context, builder,
        name: name, permanent: permanent, lazy: false);
  }

  void lazyAddSingleton<S>(
    BuildContext context,
    S Function() builder, {
    String? name,
    bool permanent = false,
  }) {
    return _add<S>(context, builder,
        name: name, permanent: permanent, lazy: true);
  }

  void addFactory<S>(
    BuildContext context,
    S Function() builder, {
    String? name,
    bool permanent = false,
  }) {
    return _add<S>(context, builder,
        name: name, permanent: permanent, lazy: false, isFactory: true);
  }

  void _add<S>(
    BuildContext context,
    S Function() builder, {
    String? name,
    required bool permanent,
    required bool lazy,
    bool isFactory = false,
  }) {
    final key = name == null ? S.toString() : S.toString() + name;
    context as InjecktorElement;

    if (!context._names.contains(key) &&
        !InjectKtor.isRegistered<S>(name: name)) {
      if (isFactory) {
        InjectKtor.addFactory<S>(builder, name: name, permanent: permanent);
      } else {
        if (lazy) {
          InjectKtor.addLazySingleton<S>(builder,
              name: name, permanent: permanent);
        } else {
          InjectKtor.addSingleton<S>(builder(),
              name: name, permanent: permanent);
        }
      }
      context._addName(key);
    }
  }

  @override
  StatelessElement createElement() => InjecktorElement(this);
}

class InjecktorElement extends StatelessElement {
  InjecktorElement(InjecktorWidget widget) : super(widget);

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

  // @override
  // void update(covariant StatelessWidget newWidget) {
  //   super.update(newWidget);
  //   _dispose();
  // }

  void _dispose() {
    for (int i = 0; i < _count; i++) {
      InjectKtor.remove(key: _names[i]);
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
