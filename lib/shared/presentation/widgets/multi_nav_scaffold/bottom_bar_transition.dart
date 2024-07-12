part of 'multi_nav_scaffold.dart';

class _DisappearingBottomNavigationBar extends StatelessWidget {
  const _DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation, // Add this parameter
    required this.navigationBar, // Add this parameter
  });

  final _BarAnimation barAnimation; // Add this variable
  final Widget navigationBar; // Add this variable

  @override
  Widget build(BuildContext context) {
    // Modify from here...
    final backgroundColor =
        CustomNavigationBarTheme.of(context).backgroundColor;

    return _BottomBarTransition(
      animation: barAnimation,
      backgroundColor: backgroundColor,
      child: navigationBar,
    );
    // ... to here.
  }
}

class _BottomBarTransition extends StatefulWidget {
  const _BottomBarTransition(
      {super.key,
      required this.animation,
      required this.backgroundColor,
      required this.child});

  final Animation<double> animation;
  final Color backgroundColor;
  final Widget child;

  @override
  State<_BottomBarTransition> createState() => _BottomBarTransitionState();
}

class _BottomBarTransitionState extends State<_BottomBarTransition> {
  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(_OffsetAnimation(parent: widget.animation));

  late final Animation<double> heightAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(_SizeAnimation(parent: widget.animation));

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Align(
          alignment: Alignment.topLeft,
          heightFactor: heightAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
