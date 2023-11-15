import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';

import 'package:meiyou/presentation/widgets/source_drop_down_button.dart';

class SourceDropDown extends StatelessWidget {
  final Map<String, BaseProvider> providersList;
  const SourceDropDown({
    super.key,
    required this.providersList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceDropDownBloc, SourceDropDownState>(
        buildWhen: (previous, current) => previous.provider != current.provider,
        builder: (context, state) {
          return SourceDropDownButton(
            providersList: providersList,
            selected: state.provider,
            onSelected: (selected) =>
                BlocProvider.of<SourceDropDownBloc>(context)
                    .add(SourceDropDownOnSelected(provider: selected)),
          );
        });
  }
}
