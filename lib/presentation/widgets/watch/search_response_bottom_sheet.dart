import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';




class SearchResponseBottomSheet extends StatelessWidget {
  final SearchResponseBloc bloc;
  final SelectedSearchResponseBloc selectedSearchResponseBloc;
  const SearchResponseBottomSheet(
      {super.key,
      required this.bloc,
      required this.selectedSearchResponseBloc});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchResponseBloc, SearchResponseState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is SearchResponseFailed) {
          print(state.error!);
        }
      },
      builder: (context, state) {
        if (state is SearchResponseSearching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchResponseSuccess) {
          final list = state.searchResponses!;
          return BlocBuilder(
              bloc: selectedSearchResponseBloc,
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 30,
                          runSpacing: 20,
                          children: List.generate(list.length, (i) {
                            return ImageButtonWrapper(
                                onTap: () {
                                  final value = list[i];
                                  if ((state as dynamic).searchResponse !=
                                      value) {
                                    selectedSearchResponseBloc.add(
                                        SelectSearchResponseFromUserSelection(
                                            value));
                                  }
                                  Navigator.pop(context);
                                },
                                child: ImageHolder.withText(
                                    imageUrl: list[i].cover,
                                    text: list[i].title));
                          }),
                        ),
                      ),
                    ),
                  ],
                );
              });
        } else {
          return Container();
        }
      },
    );
  }
}
