import 'package:flutter/material.dart';
import 'package:meiyou/core/helper/locale_helper.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/presentation/widgets/grouped_list_view.dart';

class BaseBrowseListView<T> extends StatelessWidget {
  final Map<String, List<T>> group;
  final Widget Function(BuildContext, T) itemBuilder;
  const BaseBrowseListView({
    super.key,
    required this.group,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final headerTextStyle = theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8));

    return GroupedListView(
      group: group,
      groupHeaderBuilder: (_, key) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          alignment: Alignment.centerLeft,
          child: Text(
            LocaleHelper.getSourceDisplayName(key),
            style: headerTextStyle,
          ),
        );
      },
      itemBuilder: itemBuilder,
    );
  }
}
