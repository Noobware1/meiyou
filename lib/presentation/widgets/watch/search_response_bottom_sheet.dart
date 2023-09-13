import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/search_bar.dart';

class SearchResponseBottomSheet extends StatelessWidget {
  final SearchResponseBloc bloc;
  final SourceDropDownBloc sourceDropDownBloc;
  final SelectedSearchResponseBloc selectedSearchResponseBloc;
  const SearchResponseBottomSheet({
    super.key,
    required this.sourceDropDownBloc,
    required this.bloc,
    required this.selectedSearchResponseBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceDropDownBloc, SourceDropDownState>(
      bloc: sourceDropDownBloc,
      builder: (context, state) {
        final provider = state.provider;
        return Container(
          height: context.screenHeight * 0.5,
          // set a minimum height for the bottom sheet
          constraints: const BoxConstraints(minHeight: 200),
          child: Column(
            children: [
              BlocBuilder<SelectedSearchResponseBloc,
                      SelectedSearchResponseState>(
                  bloc: selectedSearchResponseBloc,
                  builder: (context, state) {
                    return CustomSearchBar(
                      onSearch: (query) {
                        bloc.add(SearchResponseSearchWithoutSelecting(
                            provider: provider, query: query));
                      },
                      hint: state.title,
                    );
                  }),
              BlocConsumer<SearchResponseBloc, SearchResponseState>(
                bloc: bloc,
                listener: (context, state) {
                  if (state is SearchResponseFailed) {
                    print(state.error!);
                  }
                },
                builder: (context, searchResponseState) {
                  if (searchResponseState is SearchResponseSearching) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (searchResponseState is SearchResponseSuccess) {
                    final list = searchResponseState.searchResponses!;
                    return BlocBuilder<SelectedSearchResponseBloc,
                            SelectedSearchResponseState>(
                        bloc: selectedSearchResponseBloc,
                        builder: (context, state) {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 30,
                                runSpacing: 20,
                                children: List.generate(list.length, (i) {
                                  return ImageButtonWrapper(
                                      onTap: () {
                                        final value = list[i];
                                        if (state.searchResponse != value) {
                                          selectedSearchResponseBloc.add(
                                              SelectSearchResponseFromUserSelection(
                                                  value, provider));
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: ImageHolder.withText(
                                          imageUrl: list[i].cover,
                                          text: list[i].title));
                                }),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
