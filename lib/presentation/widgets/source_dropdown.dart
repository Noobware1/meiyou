import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class SourceDropDown extends StatelessWidget {
  // final void Function(BaseProvider provider) onSelected;
  // final int initialProvider;
  final Map<String, BaseProvider> providersList;
  const SourceDropDown({
    super.key,
    required this.providersList,
    // this.initialProvider = 0,
    // required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // final width = context.screenWidth;
    final bloc = BlocProvider.of<SourceDropDownBloc>(context);
    final providers = providersList.values.toList();
    final primaryColor = Colors.pink;
    // final primaryColor = context.primaryColor;

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
                borderRadius: borderRadius
                // color: Colors.blue
                ),
            height: 55,
            // width: width,
            child: BlocBuilder<SourceDropDownBloc, SourceDropDownState>(
              buildWhen: (previous, current) =>
                  previous.provider != current.provider,
              builder: (context, state) {
                return DropdownButton(
                  autofocus: true,
                  isExpanded: true,
                  // padding: const EdgeInsets.only(left: 50),
                  underline: defaultSizedBox,

                  dropdownColor: Colors.black,
                  borderRadius: borderRadius,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                  
                  onChanged: (value) {
                    if (value != null && value != state.provider) {
                      bloc.add(SourceDropDownOnSelected(provider: value));
                      
                    }

                  },
                  iconSize: 35,
                  value: state.provider,
                  items: List.generate(
                      providers.length,
                      (index) => DropdownMenuItem(
                            value: providers[index],
                            child: Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: Text(providers[index].name),
                            ),
                          )),
                );
              },
            )),
        Positioned(
          top: 0,
          left: 5,
          child: Container(
            height: 20,
            width: 60,
            alignment: Alignment.topCenter,
            // padding: EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
                color: Colors.black,
                // border: Border.all(color: primaryColor, width: 2),
                borderRadius: borderRadius
                // color: Colors.blue
                ),

            // color: getPrimaryColorDark(context),
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
