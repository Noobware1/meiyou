part of 'multi_nav_scaffold.dart';

class _DisappearingSideNavigationBar extends StatelessWidget {
  const _DisappearingSideNavigationBar({
    super.key,
    required this.railAnimation, // Add this parameter
    required this.railFabAnimation,
    // Add this parameter
    required this.navigationBar, // Add this parameter
  });

  final _SideAnimation railAnimation; // Add this variable
  final _SideFabAnimation railFabAnimation; // Add this variable
  final Widget navigationBar; // Add this variable

  @override
  Widget build(BuildContext context) {
    // Delete colorScheme
    // Modify from here ...
    final theme = CustomNavigationBarTheme.of(context);

    return _NavRailTransition(
      animation: railAnimation,
      backgroundColor: theme.backgroundColor,
      child: navigationBar,
    );
    // ... to here.
  }
}

class _NavRailTransition extends StatefulWidget {
  const _NavRailTransition(
      {super.key,
      required this.animation,
      required this.backgroundColor,
      required this.child});

  final Animation<double> animation;
  final Widget child;
  final Color backgroundColor;

  @override
  State<_NavRailTransition> createState() => _NavRailTransitionState();
}

class _NavRailTransitionState extends State<_NavRailTransition> {
  // The animations are only rebuilt by this method when the text
  // direction changes because this widget only depends on Directionality.
  late final bool ltr = Directionality.of(context) == TextDirection.ltr;
  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: ltr ? const Offset(-1, 0) : const Offset(1, 0),
    end: Offset.zero,
  ).animate(_OffsetAnimation(parent: widget.animation));
  late final Animation<double> widthAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(_SizeAnimation(parent: widget.animation));

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: AnimatedBuilder(
          animation: widthAnimation,
          builder: (context, child) {
            return Align(
              alignment: Alignment.topLeft,
              widthFactor: widthAnimation.value,
              child: FractionalTranslation(
                translation: offsetAnimation.value,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}
