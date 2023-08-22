import 'package:flutter/material.dart';
import 'package:streamify/constants/height_and_width.dart';
import 'package:streamify/widgets/image_view/image_list_view.dart'
    show ImageListViewData;
import 'package:streamify/widgets/image_view/image_list_view_with_controller.dart';

class BuildInfoListView extends StatelessWidget {
  final List<ImageListViewData> data;
  final String label;
  final double height;
  final double width;
  const BuildInfoListView(
      {super.key,
      this.width = defaultPosterBoxWidth,
      required this.data,
      required this.label,
      this.height = defaultPosterBoxHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 20),
            child: DefaultTextStyle(
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              child: Text(
                label,
                textAlign: TextAlign.left,
              ),
            )),
        ImageViewWithScrollController(
          type: ImageListViewType.basic,
          paddingAtStart: 35,
          data: data,
          height: height,
          width: width,
        )
      ],
    );
  }
}
