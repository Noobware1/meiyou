import 'package:flutter/material.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';

///    a [ValueListenable] for more advanced use cases.
class StateListenableBuilder<T> extends StatefulWidget {
  /// Creates a [StateListenableBuilder].
  ///
  /// The [child] is optional but is good practice to use if part of the widget
  /// subtree does not depend on the state of the [stateListenable].
  const StateListenableBuilder({
    super.key,
    required this.stateListenable,
    required this.builder,
    this.child,
  });

  /// The [ValueListenable] whose state you depend on in order to build.
  ///
  /// This widget does not ensure that the [ValueListenable]'s state is not
  /// null, therefore your [builder] may need to handle null values.
  final StateNotifier<T> stateListenable;

  /// A [ValueWidgetBuilder] which builds a widget depending on the
  /// [stateListenable]'s state.
  ///
  /// Can incorporate a [stateListenable] state-independent widget subtree
  /// from the [child] parameter into the returned widget tree.
  final ValueWidgetBuilder<T> builder;

  /// A [stateListenable]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the
  /// [builder] builds depends on the state of the [stateListenable]. For
  /// example, in the case where the [stateListenable] is a [String] and the
  /// [builder] returns a [Text] widget with the current [String] state, there
  /// would be no useful [child].
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _StateListenableBuilderState<T>();
}

class _StateListenableBuilderState<T> extends State<StateListenableBuilder<T>> {
  late T state;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    state = widget.stateListenable.state;
    widget.stateListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(StateListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stateListenable != widget.stateListenable) {
      oldWidget.stateListenable.removeListener(_valueChanged);
      state = widget.stateListenable.state;
      widget.stateListenable.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.stateListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      state = widget.stateListenable.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, state, widget.child);
  }
}
