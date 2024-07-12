part of 'multi_nav_scaffold.dart';

class _BarAnimation extends ReverseAnimation {
  _BarAnimation({required AnimationController parent})
      : super(
          CurvedAnimation(
            parent: parent,
            curve: const Interval(0, 1 / 5),
            reverseCurve: const Interval(1 / 5, 4 / 5),
          ),
        );
}

class _OffsetAnimation extends CurvedAnimation {
  _OffsetAnimation({required super.parent})
      : super(
          curve: const Interval(
            2 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            4 / 5,
            1,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class _SideAnimation extends CurvedAnimation {
  _SideAnimation({required super.parent})
      : super(
          curve: const Interval(0 / 5, 4 / 5),
          reverseCurve: const Interval(3 / 5, 1),
        );
}

class _SideFabAnimation extends CurvedAnimation {
  _SideFabAnimation({required super.parent})
      : super(
          curve: const Interval(3 / 5, 1),
        );
}

class _ScaleAnimation extends CurvedAnimation {
  _ScaleAnimation({required super.parent})
      : super(
          curve: const Interval(
            3 / 5,
            4 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            3 / 5,
            1,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class _ShapeAnimation extends CurvedAnimation {
  _ShapeAnimation({required super.parent})
      : super(
          curve: const Interval(
            2 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );
}

class _SizeAnimation extends CurvedAnimation {
  _SizeAnimation({required super.parent})
      : super(
          curve: const Interval(
            0 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            2 / 5,
            1,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}
