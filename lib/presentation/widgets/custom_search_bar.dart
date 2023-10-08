import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class MeiyouSearchBar extends StatefulWidget {
  final double height;
  final BorderRadius borderRadius;
  final Widget? child;
  final Function(String query) onSearch;
  const MeiyouSearchBar(
      {super.key,
      this.height = 80,
      this.child,
      this.borderRadius = const BorderRadius.all(Radius.circular(20)),
      required this.onSearch});

  @override
  State<MeiyouSearchBar> createState() => _MeiyouSearchBarState();
}

class _MeiyouSearchBarState extends State<MeiyouSearchBar> {
  static const fallbackColor = Colors.grey;
  Color color = fallbackColor;
  var borderWidth = 1.0;
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        height: widget.height + 10,
        width: context.screenWidth,
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              color = context.theme.colorScheme.primary;
              borderWidth = 3.0;
              // radius = 15;
            });
          },
          onHover: (event) {},
          onExit: (event) {
            Future.delayed(const Duration(milliseconds: 700)).then((_) {
              setState(() {
                color = fallbackColor;
                borderWidth = 1.0;
              });
            });
          },
          child: Material(
            color: Colors.transparent,
            borderRadius: widget.borderRadius,
            elevation: 8.0,
            surfaceTintColor: context.theme.colorScheme.background,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              // borderRadius: widget.borderRadius,
              onTapDown: (details) {
                print('1');
              },
              onTap: () {
                setState(() {
                  color = context.theme.colorScheme.primary;
                  borderWidth = 3.0;
                  // radius = 15;
                });
              },
              child: Stack(children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: widget.height,
                    width: context.screenWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: color, width: borderWidth),
                      borderRadius: widget.borderRadius,
                    ),
                    child: TextField(
                      controller: controller,
                      style: TextStyle(fontSize: 40),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        constraints: BoxConstraints(
                          maxWidth: context.screenWidth / 1.2,
                        ),
                        prefixIcon: IconButton(
                            disabledColor: Colors.grey,
                            icon: Icon(Icons.search, color: color),
                            onPressed: () => widget.onSearch(controller.text)),
                        // hintText: controller.text,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.clear();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    // child: Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10),
                    //       child: Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Icon(
                    //           Icons.search_rounded,
                    //           color: color,
                    //           size: widget.height / 2,
                    //         ),
                    //       ),
                    //     ),
                    //     ,
                    //     // if (widget.child != null)
                    //     //   Expanded(child: widget.child!),
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 10.0),
                    //       child: Align(
                    //         alignment: Alignment.centerRight,
                    //         child: Icon(
                    //           Icons.search_rounded,
                    //           color: color,
                    //           size: widget.height / 2,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 50,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    color: Colors.black,
                    child: DefaultTextStyle(
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                      ),
                      child: Text(
                        'Search',
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// class _MyValue {
//   final Color color;
//    final double boderWidth;

//   const _MyValue(this.color, this.boderWidth);
// }

// class _Listener<_MyValue> extends ValueNotifier<_MyValue> {
// static const Color fallbackColor = Colors.grey;

//   _Listener() : super(_MyValue(fallbackColor, 1.0));

// changeC




// }
