import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/height_and_width.dart'
    show smallScreenSize;
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/icon_with_text.dart';

enum _ButtonDirection {
  right,
  left,
}

class _ForLagerScreens extends StatelessWidget {
  final VoidCallback onTapMyList;
  final VoidCallback onTapPlay;
  final VoidCallback onTapInfo;
  const _ForLagerScreens(
      {super.key,
      required this.onTapMyList,
      required this.onTapPlay,
      required this.onTapInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: onTapMyList,
          icon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
              textStyle: const MaterialStatePropertyAll(TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
              overlayColor:
                  MaterialStatePropertyAll(Colors.black.withOpacity(0.5))),
          label: const Text(
            'My List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        addHorizontalSpace(10),
        ElevatedButton.icon(
          onPressed: onTapInfo,
          icon: const Icon(Icons.info_outline),
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
              backgroundColor:
                  MaterialStatePropertyAll(Colors.black.withOpacity(0.5)),
              textStyle: const MaterialStatePropertyAll(
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          label: const Text('Info'),
        ),
        // addHorizontalSpace((context.screenWidth / 3) + 110),
      ],
    );
  }
}

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
    if (context.screenWidth < smallScreenSize) {
      return _ForSmallerScreens(
        onTapInfo: onTapInfo,
        onTapMyList: onTapMyList,
        onTapPlay: onTapPlay,
      );
    }
    return _ForLagerScreens(
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
      {super.key,
      required this.onTapMyList,
      required this.onTapPlay,
      required this.onTapInfo});

  static const _paddingLeft = EdgeInsets.only(left: 20);
  static const _paddingRight = EdgeInsets.only(right: 20);

  Widget _paddedButton(
      {required BuildContext context,
      required Widget child,
      required _ButtonDirection direction}) {
    return Expanded(
      child: Padding(
        padding:
            direction == _ButtonDirection.right ? _paddingLeft : _paddingRight,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: context.screenWidth,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _paddedButton(
            context: context,
            child: IconButtonWithText(
              icon: const Icon(Icons.add),
              text: 'My List',
              onTap: onTapMyList,
            ),
            direction: _ButtonDirection.left),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    overlayColor: MaterialStatePropertyAll(Colors.grey),
                    iconColor: MaterialStatePropertyAll(Colors.black),
                    iconSize: MaterialStatePropertyAll(25),
                    fixedSize: MaterialStatePropertyAll(Size(90, 45))),
                onPressed: onTapPlay,
                icon: const Icon(Icons.play_arrow),
                label: const DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    child: Text('Play'))),
          ),
        ),
        _paddedButton(
            context: context,
            child: IconButtonWithText(
              icon: const Icon(Icons.info_outline),
              text: 'Info',
              onTap: onTapInfo,
            ),
            direction: _ButtonDirection.right)
      ]),
    );
  }
}
