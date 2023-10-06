import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart'
    show smallScreenSize;
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

// class _ForLagerScreens extends StatelessWidget {
//   final VoidCallback onTapMyList;
//   final VoidCallback onTapPlay;
//   final VoidCallback onTapInfo;
//   const _ForLagerScreens(
//       {required this.onTapMyList,
//       required this.onTapPlay,
//       required this.onTapInfo});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         ElevatedButton.icon(
//           onPressed: onTapMyList,
//           icon: const Icon(
//             Icons.add,
//           ),
//           style: ButtonStyle(
//             iconColor: MaterialStatePropertyAll(
//                 context.theme.brightness == Brightness.dark
//                     ? Colors.black
//                     : Colors.white),
//             padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
//             backgroundColor: MaterialStatePropertyAll(
//                 context.theme.brightness == Brightness.dark
//                     ? Colors.white
//                     : Colors.black),
//             textStyle: const MaterialStatePropertyAll(TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             )),
//             overlayColor: MaterialStatePropertyAll(
//                 context.theme.brightness == Brightness.dark
//                     ? Colors.white
//                     : Colors.black),
//           ),
//           label: Text('My List',
//               style: TextStyle(
//                   color: context.theme.brightness == Brightness.dark
//                       ? Colors.black
//                       : Colors.white)),
//         ),
//         addHorizontalSpace(10),
//         ElevatedButton.icon(
//           onPressed: onTapInfo,
//           icon: const Icon(Icons.info_outline),
//           style: ButtonStyle(
//               padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
//               backgroundColor:
//                   MaterialStatePropertyAll(Colors.black.withOpacity(0.5)),
//               textStyle: const MaterialStatePropertyAll(
//                   TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
//           label: const Text('Info'),
//         ),
//         // addHorizontalSpace((context.screenWidth / 3) + 110),
//       ],
//     );
//   }
// }

class BannerButtons extends StatelessWidget {
  final VoidCallback onTapMyList;
  final VoidCallback onTapPlay;
  final VoidCallback onTapInfo;
  const BannerButtons(
      {super.key,
      required this.onTapMyList,
      required this.onTapPlay,
      required this.onTapInfo});

  @override
  Widget build(BuildContext context) {
    return _ForSmallerScreens(
      onTapInfo: onTapInfo,
      onTapMyList: onTapMyList,
      onTapPlay: onTapPlay,
    );
  }
}

class _ForSmallerScreens extends StatelessWidget {
  final VoidCallback onTapMyList;
  final VoidCallback onTapPlay;
  final VoidCallback onTapInfo;
  const _ForSmallerScreens(
      {required this.onTapMyList,
      required this.onTapPlay,
      required this.onTapInfo});

  static const _paddingLeft = EdgeInsets.only(left: 20);
  static const _paddingRight = EdgeInsets.only(right: 20);

  // Widget _paddedButton(
  //     {required BuildContext context,
  //     required Widget child,
  //     required _ButtonDirection direction}) {
  //   return Expanded(
  //     child: Padding(
  //       padding:
  //           direction == _ButtonDirection.right ? _paddingLeft : _paddingRight,
  //       child: child,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool bigger = constraints.maxWidth > smallScreenSize;
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
              onPressed: onTapPlay,
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
    // return SizedBox(
    //   height: 70,
    //   width: context.screenWidth,
    //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    //     _paddedButton(
    //         context: context,
    //         child: IconButtonWithText(
    //           icon: const Icon(Icons.add),
    //           text: 'My List',
    //           onTap: onTapMyList,
    //         ),
    //         direction: _ButtonDirection.left),
    //     Center(
    //       child: Padding(
    //           padding: const EdgeInsets.only(bottom: 10),
    //           child: _PlayButton(onTapPlay: onTapPlay)),
    //     ),
    //     _paddedButton(
    //         context: context,
    //         child: IconButtonWithText(
    //           icon: const Icon(Icons.info_outline),
    //           text: 'Info',
    //           onTap: onTapInfo,
    //         ),
    //         direction: _ButtonDirection.right)
    //   ]),
    // );
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
