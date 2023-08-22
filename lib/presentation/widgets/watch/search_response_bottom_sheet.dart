import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';

class SearchResponseBottomSheet extends StatelessWidget {
  final SearchResponseBloc bloc;
  const SearchResponseBottomSheet({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchResponseBloc, SearchResponseState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SearchResponseStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchResponseStateWithData) {
          final list = state.searchResponses!;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 30,
                    runSpacing: 20,
                    children: List.generate(list.length, (i) {
                      return ImageHolder.withText(
                          imageUrl: list[i].cover, text: list[i].title);
                    }),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
