import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class SourceDropDownButton extends StatelessWidget {
  final Map<String, BaseProvider> providersList;
  final BaseProvider? selected;
  final void Function(BaseProvider selected) onSelected;
  const SourceDropDownButton({
    super.key,
    required this.providersList,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final providers = providersList.values.toList();
    final primaryColor = context.theme.colorScheme.primary;

    const borderRadius = BorderRadius.all(
      Radius.circular(15),
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        addVerticalSpace(60),
        Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 2),
              borderRadius: borderRadius,
              color: context.theme.scaffoldBackgroundColor),
          height: 55,
          // width: width,
          child: DropdownButton(
            autofocus: true,
            isExpanded: true,
            underline: defaultSizedBox,
            dropdownColor: context.theme.colorScheme.tertiary,
            borderRadius: borderRadius,
            style: TextStyle(
                color: context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15),
            onChanged: (value) {
              if (value != null && value.runtimeType != selected.runtimeType) {
                onSelected.call(value);
              }
            },
            iconSize: 35,
            value: providers.tryfirstWhere((e) =>
                    e == selected || e.runtimeType == selected.runtimeType) ??
                providers.first,
            items: List.generate(
                providers.length,
                (index) => DropdownMenuItem(
                      value: providers[index],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Text(providers[index].name),
                      ),
                    )),
          ),
        ),
        Positioned(
          top: 0,
          left: 5,
          child: Container(
            height: 20,
            width: 60,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: borderRadius),
            child: Text(
              'Source',
              style: TextStyle(
                fontSize: 15,
                color: primaryColor,
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
            child: Icon(Icons.source, color: primaryColor))
      ],
    );
  }
}
