import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/blocs/search_page_cubit.dart';
import 'package:meiyou/presentation/emoticons_widget.dart';
import 'package:meiyou/presentation/no_plugin.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/error_widget.dart';
import 'package:meiyou/presentation/widgets/image_view/image_button_wrapper.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/plugin_selector_floating_action_button.dart';
import 'package:meiyou/presentation/widgets/responsive_layout.dart';
import 'package:meiyou_extenstions/models.dart';

void navigateToInfo(SearchResponse searchResponse, BuildContext context) {
  return context.go('/search/info', extra: searchResponse);
}

class _ForMobile extends StatelessWidget {
  const _ForMobile({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.w600);
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            // addVerticalSpace(20),
            Row(
              children: [
                const Text(
                  'Search On',
                  style: textStyle,
                ),
                addHorizontalSpace(10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(context.bloc<PluginSelectorCubit>().state.name,
                      style: textStyle),
                )
              ],
            ),
            addVerticalSpace(10),
            Row(
              children: [
                Expanded(
                    child: CustomSearchBar(
                  onSearch: (query) {
                    if (context.tryBloc<SearchPageCubit>() != null) {
                      context.bloc<SearchPageCubit>().search(query);
                    }
                  },
                  height: 50,
                )),
                addHorizontalSpace(5),
                Material(
                  type: MaterialType.button,
                  color: context.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                  child: const InkWell(
                    child: SizedBox(
                        height: 45,
                        width: 45,
                        child: Icon(
                          Icons.settings_outlined,
                          size: 30,
                        )),
                  ),
                )
              ],
            ),
            addVerticalSpace(20),
            if (context.tryBloc<SearchPageCubit>() != null)
              Expanded(
                child: BlocBuilder<SearchPageCubit,
                        AsyncState<List<SearchResponse>>>(
                    builder: (context, state) {
                  if (state is SearchPageInital) {
                    return defaultSizedBox;
                  }

                  return state.when(
                      data: (data) {
                        if (data.isEmpty) return const NoResults();
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      defaultPosterBoxWidth + 30,
                                  mainAxisExtent: 240,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 240,
                              width: defaultPosterBoxWidth,
                              child: ImageButtonWrapper(
                                onTap: () {
                                  navigateToInfo(data[index], context);
                                },
                                child: ImageHolder.withWatchData(
                                  textStyle: const TextStyle(fontSize: 15),
                                  watchDataTextStyle:
                                      const TextStyle(fontSize: 14),
                                  width: defaultPosterBoxWidth,
                                  height: defaultPosterHeight,
                                  text: data[index].title,
                                  current: data[index].current,
                                  total: data[index].total,
                                  imageUrl: data[index].poster,
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        );
                      },
                      error: (error) {
                        return CustomErrorWidget(
                          error: error.message,
                          onRetry: () {
                            context.bloc<SearchPageCubit>().retryLastSearch();
                          },
                        );
                      },
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ));
                }),
              )
          ],
        ),
      ),
    );
  }
}

class _ForDesktop extends StatelessWidget {
  const _ForDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 35, fontWeight: FontWeight.w700);
    return Padding(
      padding: const EdgeInsets.only(left: 100, right: 100, top: 30),
      child: Column(
        children: [
          // addVerticalSpace(20),
          Row(
            children: [
              const Text(
                'Search On',
                style: textStyle,
              ),
              addHorizontalSpace(10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(context.bloc<PluginSelectorCubit>().state.name,
                    style: textStyle),
              )
            ],
          ),
          addVerticalSpace(10),
          Row(
            children: [
              Expanded(child: CustomSearchBar(
                onSearch: (query) {
                  if (context.tryBloc<SearchPageCubit>() != null) {
                    context.bloc<SearchPageCubit>().search(query);
                  }
                },
              )),
              addHorizontalSpace(5),
              Material(
                type: MaterialType.button,
                color: context.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                child: const InkWell(
                  child: SizedBox(
                      height: 45,
                      width: 45,
                      child: Icon(
                        Icons.settings_outlined,
                        size: 30,
                      )),
                ),
              )
            ],
          ),
          addVerticalSpace(20),
          if (context.tryBloc<SearchPageCubit>() != null)
            Expanded(
              child: BlocBuilder<SearchPageCubit,
                      AsyncState<List<SearchResponse>>>(
                  builder: (context, state) {
                if (state is SearchPageInital) {
                  return defaultSizedBox;
                }
                return state.when(
                    data: (data) {
                      if (data.isEmpty) return const NoResults();

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                    defaultPosterBoxWidthDesktop + 30,
                                mainAxisExtent: 290,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 290,
                            width: defaultPosterBoxWidth,
                            child: ImageButtonWrapper(
                              onTap: () {
                                navigateToInfo(data[index], context);
                              },
                              child: ImageHolder.withWatchData(
                                textStyle: const TextStyle(fontSize: 16),
                                watchDataTextStyle:
                                    const TextStyle(fontSize: 14),
                                width: defaultPosterBoxWidthDesktop,
                                height: defaultPosterBoxHeightDesktop,
                                text: data[index].title,
                                current: data[index].current,
                                total: data[index].total,
                                imageUrl: data[index].poster,
                              ),
                            ),
                          );
                        },
                        itemCount: data.length,
                      );
                    },
                    error: (error) {
                      return CustomErrorWidget(
                        error: error.message,
                        onRetry: () {
                          context.bloc<SearchPageCubit>().retryLastSearch();
                        },
                      );
                    },
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ));
              }),
            )
        ],
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton:
            const PluginFloatingActionButton(heroTag: 'search'),
        body: BlocBuilder<PluginRepositoryUseCaseProviderCubit,
                PluginManagerUseCaseProviderState>(
            builder: (context, usecaseProvider) {
          return usecaseProvider.when(
              error: (error) => CustomErrorWidget(
                  error: error.message,
                  onRetry: () {
                    context
                        .bloc<PluginRepositoryUseCaseProviderCubit>()
                        .initFromContext(context);
                  }),
              done: (data) {
                return BlocProvider(
                  create: (context) => SearchPageCubit(data.loadSearchUseCase),
                  child: const ResponsiveLayout(
                      forSmallScreen: _ForMobile(),
                      forBiggerScreen: _ForDesktop()),
                );
              },
              loading: () => const ResponsiveLayout(
                  forSmallScreen: _ForMobile(), forBiggerScreen: _ForDesktop()),
              noPlugin: () => const NoPlugin());
        }));
  }
}

class NoResults extends StatelessWidget {
  const NoResults({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: EmoticonsWidget(text: 'No Results Found!', emoticon: '(つ﹏<。)'));
  }
}

class CustomSearchBar extends StatefulWidget {
  final void Function(String query) onSearch;
  final double? height;
  final String? hint;
  const CustomSearchBar(
      {super.key, required this.onSearch, this.hint, this.height});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 5,
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onSearch,
        decoration: InputDecoration(
          iconColor: context.theme.colorScheme.primary,
          enabled: true,
          isDense: true,
          filled: true,
          fillColor: context.theme.colorScheme.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          constraints: BoxConstraints(
            maxHeight: widget.height ?? double.infinity,
            maxWidth: width,
          ),
          prefixIcon: IconButton(
              disabledColor: Colors.grey,
              icon: const Icon(Icons.search),
              onPressed: () => widget.onSearch(_controller.text)),
          hintText: 'Search...',
          suffixIcon: IconButton(
            onPressed: () {
              _controller.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
