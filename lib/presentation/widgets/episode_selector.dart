import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/constants/animation_duration.dart';
import 'package:streamify/constants/default_sized_box.dart';
import 'package:streamify/helpers/color_from_theme.dart';
import 'package:streamify/notifers/episodes_notifer.dart';
import 'package:streamify/widgets/add_space.dart';

class EpisodeSelector extends StatelessWidget {
  const EpisodeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EpisodeViewNotifer>(
      builder: (context, value, child) => value.len == 1
          ? child!
          : SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, i) => addHorizontalSpace(10),
                  itemCount: value.len,
                  itemBuilder: (context, i) {
                    return Material(
                      color: value.selectedEpRow != value.keys[i]
                          ? Colors.black
                          : getPrimaryColor(context),
                      animationDuration: animationDuration,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        splashColor: getPrimaryColor(context),
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          if (value.selectedEpRow != value.keys[i]) {
                            value.update(value.keys[i]);
                            print('updated');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: value.selectedEpRow != value.keys[i]
                                    ? Colors.grey
                                    : getPrimaryColor(context),
                                width: 2),
                          ),
                          child: Text(value.keys[i],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  }),
            ),
      child: defaultSizedBox,
    );
  }
}
