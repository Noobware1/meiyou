import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Copied Form IndexedStack
class CustomIndexedStack extends StatelessWidget {
  /// Creates a [Stack] widget that paints a single child.
  ///
  /// The [index] argument must not be null.
  const CustomIndexedStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  });

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See [Stack.alignment] for more information.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// How to size the non-positioned children in the stack.
  ///
  /// Defaults to [StackFit.loose].
  ///
  /// See [Stack.fit] for more information.
  final StackFit sizing;

  /// The index of the child to show.
  ///
  /// If this is null, none of the children will be shown.
  final int? index;

  /// The child widgets of the stack.
  ///
  /// Only the child at index [index] will be shown.
  ///
  /// See [Stack.children] for more information.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> wrappedChildren =
        List<Widget>.generate(children.length, (int i) {
      return Visibility(
        maintainState: true,
        visible: i == index,
        child: children[i],
      );
    });
    return _RawIndexedStack(
      alignment: alignment,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      sizing: sizing,
      index: index,
      children: wrappedChildren,
    );
  }
}

/// The render object widget that backs [CustomIndexedStack].
class _RawIndexedStack extends Stack {
  /// Creates a [Stack] widget that paints a single child.
  const _RawIndexedStack({
    super.alignment,
    super.textDirection,
    super.clipBehavior,
    StackFit sizing = StackFit.loose,
    this.index = 0,
    super.children,
  }) : super(fit: sizing);

  /// The index of the child to show.
  final int? index;

  @override
  RenderIndexedStack createRenderObject(BuildContext context) {
    assert(_debugCheckHasDirectionality(context));
    return RenderIndexedStack(
      index: index,
      fit: fit,
      clipBehavior: clipBehavior,
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
    );
  }

  bool _debugCheckHasDirectionality(BuildContext context) {
    if (alignment is AlignmentDirectional && textDirection == null) {
      assert(debugCheckHasDirectionality(
        context,
        why: "to resolve the 'alignment' argument",
        hint: alignment == AlignmentDirectional.topStart
            ? "The default value for 'alignment' is AlignmentDirectional.topStart, which requires a text direction."
            : null,
        alternative:
            "Instead of providing a Directionality widget, another solution would be passing a non-directional 'alignment', or an explicit 'textDirection', to the $runtimeType.",
      ));
    }
    return true;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderIndexedStack renderObject) {
    assert(_debugCheckHasDirectionality(context));
    renderObject
      ..index = index
      ..fit = fit
      ..clipBehavior = clipBehavior
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context);
  }

  @override
  MultiChildRenderObjectElement createElement() {
    return _IndexedStackElement(this);
  }
}

class _IndexedStackElement extends MultiChildRenderObjectElement {
  _IndexedStackElement(_RawIndexedStack super.widget);

  @override
  _RawIndexedStack get widget => super.widget as _RawIndexedStack;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    final int? index = widget.index;
    // If the index is null, no child is onstage. Otherwise, only the child at
    // the selected index is.
    if (index != null && children.isNotEmpty) {
      visitor(children.elementAt(index));
    }
  }
}
