import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/presentation/core/grouped_list_view.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/widgets/extension_tile.dart';

abstract class ExtensionTab<Type> extends StatelessWidget {
  const ExtensionTab({super.key});

  StateFlow<Map<String, List<Type>>> getFlow();

  Widget itemBuilder(BuildContext context, String language, Type value);

  Widget _header({
    required String language,
    required EdgeInsets padding,
    required TextStyle headerTextStyle,
  }) {
    return Padding(
      padding: padding,
      child: Text(language, style: headerTextStyle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenSize.isMobile;
    final TextTheme textTheme = context.theme.textTheme;
    final TextStyle? headerTextStyle =
        isMobile ? textTheme.titleMedium : textTheme.titleLarge;

    return StateFlowBuilder(
      flow: getFlow(),
      builder: (context, value) {
        return GroupedListView(
          group: value,
          groupHeaderBuilder: (context, key) => _header(
              language: key,
              padding: const EdgeInsets.only(
                  left: 25, top: 15, bottom: 15, right: 25),
              headerTextStyle: headerTextStyle!),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
