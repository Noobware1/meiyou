import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/widgets/selected_search_response_widget.dart';

class SelectedSearchResponseWidgetForWatchView extends StatelessWidget {
  final SelectedSearchResponseBloc selectedSearchResponseBloc;
  const SelectedSearchResponseWidgetForWatchView(
      {super.key, required this.selectedSearchResponseBloc});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectedSearchResponseBloc,
            SelectedSearchResponseState>(
        bloc: selectedSearchResponseBloc,
        listener: (context, state) {
          if (state is SelectedSearchResponseNotFound) {
            showSnackBAr(context, text: state.error.toString());
          }
        },
        listenWhen: (a, b) => b is SelectedSearchResponseNotFound,
        builder: (context, state) {
          return SelectedSearchResponseWidget(title: state.title);
        });
  }
}
