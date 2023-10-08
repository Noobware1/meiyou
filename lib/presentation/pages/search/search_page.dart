import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/get_meta_results_usecase.dart';
import 'package:meiyou/presentation/pages/search/state/bloc/search_page_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/presentation/widgets/search_bar.dart';
// import 'package:meiyou/presentation/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchPageBloc searchPageBloc;

  @override
  void initState() {
    searchPageBloc = SearchPageBloc(
        RepositoryProvider.of<MetaProviderRepositoryContainer>(context)
            .get<GetSearchUseCase>());

    super.initState();
  }

  @override
  void dispose() {
    searchPageBloc.close();
    super.dispose();
  }

  bool selected = false;

  Color _changeColorOnSelected(bool selected, BuildContext context) {
    return selected
        ? context.theme.colorScheme.background
        : context.theme.colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: Column(
        children: [
          addVerticalSpace(50),
          CustomSearchBar(
              onSearch: (query) => searchPageBloc.add(Search(query))),
          addVerticalSpace(10),
          // FilterChip(
          //     backgroundColor: context.theme.colorScheme.background,
          //     selectedColor: context.theme.colorScheme.primary,
          //     iconTheme: IconThemeData(
          //         color: _changeColorOnSelected(selected, context)),
          //     label: Text(
          //       'Anime',
          //       style: TextStyle(
          //         color: _changeColorOnSelected(selected, context),
          //       ),
          //     ),

          //     selected: selected,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(5))),
          //     onSelected: (selected) {
          //       setState(() {
          //         this.selected = selected;
          //       });
          //     }),
          // addVerticalSpace(10),
          Expanded(
              child: SingleChildScrollView(
            child: BlocBuilder<SearchPageBloc, SearchPageState>(
              bloc: searchPageBloc,
              builder: (context, state) {
                if (state is SearchPageLoading) {
                  return const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is SearchPageFailed) {
                  return DefaultTextStyle(
                    style: const TextStyle(
                        inherit: true,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    child: Text(
                      state.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is SearchPageSucess) {
                  return Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: List.generate(
                        state.results.metaResponses.length,
                        (index) => ImageButtonWrapper(
                            onTap: () {
                              context.go('$searchRoute/$watch',
                                  extra: state.results.metaResponses[index]);
                            },
                            child: ImageHolder.withText(
                                imageUrl:
                                    state.results.metaResponses[index].poster ??
                                        '',
                                text: state.results.metaResponses[index]
                                    .nonNullTitle))),
                  );
                } else {
                  return defaultSizedBox;
                }
              },
            ),
          )),
          addVerticalSpace(40),
        ],
      ),
    );
  }
}
