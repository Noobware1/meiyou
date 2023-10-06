import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  final String text;
  const ArrowButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: const Duration(milliseconds: 200),
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
            // stream: null,
            builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Visibility(
                    visible: isSelected,
                    replacement: const SizedBox(
                      height: 30,
                      width: 30,
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        Icons.done,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    text,
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? null : Colors.grey,
                        fontSize: 18),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
