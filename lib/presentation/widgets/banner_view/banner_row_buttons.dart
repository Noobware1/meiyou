import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/screen_size.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class BannerButtons extends StatelessWidget {
  final VoidCallback onTapMyList;
  final VoidCallback onTapWatchNow;
  const BannerButtons({
    super.key,
    required this.onTapMyList,
    required this.onTapWatchNow,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? _ForSmallerScreens(
            onTapMyList: onTapMyList,
            onTapWatchNow: onTapWatchNow,
          )
        : _ForBiggerScreens(
            onTapMyList: onTapMyList,
            onTapWatchNow: onTapWatchNow,
          );
  }
}

class _ForBiggerScreens extends StatelessWidget {
  final VoidCallback onTapMyList;
  final VoidCallback onTapWatchNow;

  const _ForBiggerScreens({
    required this.onTapMyList,
    required this.onTapWatchNow,
  });

  static const _defaultPadding = MaterialStatePropertyAll(
    EdgeInsets.fromLTRB(10, 15, 15, 15),
  );

  static const _defaultIconSize = MaterialStatePropertyAll(30.0);

  static const _defaultShape = MaterialStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(45))));

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle =
        TextStyle(color: context.theme.colorScheme.onSurface, fontSize: 17);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: ElevatedButton.icon(
            style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: _defaultPadding,
                overlayColor: MaterialStatePropertyAll(
                    context.theme.colorScheme.surface.withOpacity(0.2)),
                iconSize: _defaultIconSize,
                shape: _defaultShape),
            onPressed: onTapWatchNow,
            icon: Icon(Icons.play_arrow_rounded,
                color: context.theme.colorScheme.onSurface),
            label: Text('Watch Now', style: defaultTextStyle),
          ),
        ),
        addHorizontalSpace(10),
        Flexible(
          child: ElevatedButton.icon(
            onPressed: onTapMyList,
            icon: Icon(
              Icons.add,
              color: context.theme.colorScheme.onSurface,
            ),
            label: Text('My List',
                textAlign: TextAlign.start, style: defaultTextStyle),
            style: ButtonStyle(
                padding: _defaultPadding,
                iconSize: _defaultIconSize,
                backgroundColor: MaterialStatePropertyAll(
                    context.theme.colorScheme.onSurface.withOpacity(0.2)),
                overlayColor: MaterialStatePropertyAll(
                    context.theme.colorScheme.surface.withOpacity(0.2)),
                shape: _defaultShape),
          ),
        )
      ],
    );
  }
}

class _ForSmallerScreens extends StatelessWidget {
  final VoidCallback onTapMyList;
  final VoidCallback onTapWatchNow;
  
  const _ForSmallerScreens(
      {required this.onTapMyList,
  required this.onTapWatchNow});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool bigger = constraints.maxWidth > mobileScreenSize;
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  padding: MaterialStatePropertyAll(
                      bigger ? const EdgeInsets.all(10) : null),
                  overlayColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.surface.withOpacity(0.2)),
                  iconSize: MaterialStatePropertyAll(bigger ? 30 : 25),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)))),
              onPressed: onTapWatchNow,
              icon: Icon(Icons.play_arrow_rounded,
                  color: context.theme.colorScheme.onSurface),
              label: Text(
                'Watch Now',
                style: TextStyle(
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          addHorizontalSpace(10),
          Flexible(
            child: ElevatedButton.icon(
              onPressed: onTapMyList,
              icon: Icon(
                Icons.add,
                color: context.theme.colorScheme.onSurface,
              ),
              label: Text(
                'My List',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      bigger ? const EdgeInsets.all(10) : null),
                  iconSize: MaterialStatePropertyAll(bigger ? 30 : 25),
                  backgroundColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.onSurface.withOpacity(0.2)),
                  overlayColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.surface.withOpacity(0.2)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)))),
            ),
          )
        ],
      );
    });
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onTapPlay;
  const _PlayButton({required this.onTapPlay});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                context.theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            overlayColor: MaterialStatePropertyAll(
                context.theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            iconColor: MaterialStatePropertyAll(
                context.theme.brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white),
            iconSize: const MaterialStatePropertyAll(20),
            fixedSize: const MaterialStatePropertyAll(Size(100, 45))),
        onPressed: onTapPlay,
        icon: const Icon(Icons.play_arrow),
        label: DefaultTextStyle(
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: context.theme.brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white),
            child: const Text('Play')));
  }
}
