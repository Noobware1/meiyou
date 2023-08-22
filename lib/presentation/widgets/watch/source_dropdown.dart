import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/constants/colors.dart';
import 'package:streamify/constants/default_sized_box.dart';
import 'package:streamify/helpers/color_from_theme.dart';
import 'package:streamify/notifers/watch_notifer.dart';
import 'package:streamify/providers/base_parser.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/providers/providers.dart';
import 'package:streamify/utils/http_error_handler.dart';
import 'package:streamify/widgets/add_space.dart';

class SourceDropDown extends StatelessWidget {
  final List<Lazier<BaseParser>> sources;
  // final void Function(BaseParser source) onSelected;
  const SourceDropDown({super.key, required this.sources});

  static const _borderRadius = BorderRadius.all(
    Radius.circular(15),
  );

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<MediaDetails>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          addVerticalSpace(60),
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                border: Border.all(color: getPrimaryColor(context), width: 2),
                borderRadius: _borderRadius
                // color: Colors.blue
                ),
            height: 55,
            width: MediaQuery.of(context).size.width,
            child: Consumer<WatchNotifer>(
              builder: (context, value, child) {
                return DropdownButton<BaseParser>(
                    autofocus: true,
                    isExpanded: true,
                    padding: const EdgeInsets.only(left: 60),
                    underline: defaultSizedBox,
                    dropdownColor: bestGrey,
                    borderRadius: _borderRadius,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                    onChanged: (i) {
                      if (i != null && i != value.parser) {
                        value.updateParser(i);
                        value.updateSearchResponse(tryWithAsync(context,
                            () => providers.search(value.parser, media)));
                      }
                    },
                    value: value.parser,
                    iconSize: 35,
                    items: List.generate(
                        sources.length,
                        (index) => DropdownMenuItem(
                              value: sources[index].provider,
                              child: Text(
                                sources[index].name,
                              ),
                            )));
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 5,
            child: Container(
              height: 15,
              width: 60,
              alignment: Alignment.topCenter,
              // padding: EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                  color: getPrimaryColorDark(context),
                  // border: Border.all(color: getPrimaryColor(context), width: 2),
                  borderRadius: _borderRadius
                  // color: Colors.blue
                  ),

              // color: getPrimaryColorDark(context),
              child: Text(
                'Source',
                style: TextStyle(
                  fontSize: 15,
                  color: getPrimaryColor(context),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Positioned(
              top: 10,
              bottom: 5,
              left: 15,
              child: Icon(Icons.source, color: getPrimaryColor(context)))
        ],
      ),
    );
  }
}
