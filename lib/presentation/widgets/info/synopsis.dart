import 'package:flutter/material.dart';
import 'package:streamify/widgets/resizeable_text.dart';

class BuildSynopsis extends StatelessWidget {
  final String text;
  const BuildSynopsis({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(left: 35, bottom: 10),
            child: DefaultTextStyle(
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              child: Text(
                'Synopsis',
                textAlign: TextAlign.left,
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35),
          child: ResizeableTextWidget(text: text),
        )
      ],
    );
  }
}