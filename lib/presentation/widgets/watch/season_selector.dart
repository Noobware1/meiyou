import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/constants/animation_duration.dart';
// import 'package:streamify/constants/colors.dart';
import 'package:streamify/helpers/color_from_theme.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/notifers/watch_notifer.dart';

class SeasonSelector extends StatelessWidget {
  const SeasonSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WatchViewNotifer>(context, listen: false);
    return funWrapWithInkWell(
      callback: () => _showSeasons(context, provider),
      child: Container(
        // color: Colors.grey.withOpacity(  0.1),
        constraints: const BoxConstraints(
          minWidth: 120,
          maxWidth: 140,
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Consumer<WatchViewNotifer>(
          builder: (context, value, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Season ${value.season?.number}',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
      ),
    );
  }

  Future _showSeasons(BuildContext context, WatchViewNotifer value) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              elevation: 10,
              backgroundColor: getPrimaryColorDark(context),
              alignment: Alignment.center,
              child: ChangeNotifierProvider.value(
                value: value,
                builder: (context, child) {
                  return Consumer<WatchViewNotifer>(
                      builder: (context, value, child) => SizedBox(
                            height: 300,
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: value.seasons!.length,
                                itemBuilder: (context, index) =>
                                    _buildSeasonButton(value.seasons![index]),
                              ),
                            ),
                          ));
                },
              ),
            ));
  }

  Widget _buildSeasonButton(Season season) {
    return Material(
      type: MaterialType.transparency,
      animationDuration: animationDuration,
      child: Consumer<WatchViewNotifer>(
        builder: (context, value, child) => InkWell(
          onTap: () {
            if (season.number != value.season?.number) {
              value.updateSeason(season);
              value.updateLoadResponseForNextSeason(season);
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Visibility(
                  visible: season.number == value.season?.number,
                  replacement: const SizedBox(
                    height: 40,
                    width: 60,
                  ),
                  child: const SizedBox(width: 60, child: Icon(Icons.done)),
                ),
                child!
              ],
            ),
          ),
        ),
        child: Text(
          'Season ${season.number}',
          style: const TextStyle(
              color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

Widget funWrapWithInkWell(
    {required VoidCallback callback, required Widget child}) {
  return Material(
    color: Colors.grey.withOpacity(0.1),
    // type: MaterialType.transparency,
    animationDuration: animationDuration,
    child: InkWell(
      onTap: callback,
      // splashColor: Colors.white,
      child: child,
    ),
  );
}
