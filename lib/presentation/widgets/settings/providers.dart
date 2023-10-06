import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/provider_list_container.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_providers_use_case.dart';
import 'package:meiyou/domain/usecases/providers_repository_usecases/get_default_provider_usecase.dart';
import 'package:meiyou/domain/usecases/providers_repository_usecases/save_default_provider_usecase.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/source_drop_down_button.dart';

class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key});

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  static final labelTextStyle = TextStyle(fontSize: isMobile ? 15 : 18);

  late final String dirPath;

  late final _titleTextStyle = TextStyle(
      color: context.theme.colorScheme.primary,
      fontSize: isMobile ? 15 : 18,
      fontWeight: FontWeight.w400);

  BaseProvider? defaultAnimeProvider;

  BaseProvider? defaultMovieProvider;

  @override
  void initState() {
    dirPath =
        RepositoryProvider.of<AppDirectories>(context).settingsDirectory.path;
    print(dirPath);

    final GetDefaultProviderUseCase getDefaultProviderUseCase =
        RepositoryProvider.of<ProvidersRepositoryContainer>(context)
            .get<GetDefaultProviderUseCase>();

    Future.microtask(() async {
      defaultMovieProvider = await getDefaultProviderUseCase
          .call(GetDefaultProviderUseCaseParams(dirPath, ProviderType.movie));

      defaultAnimeProvider = await getDefaultProviderUseCase
          .call(GetDefaultProviderUseCaseParams(dirPath, ProviderType.anime));

      print(defaultMovieProvider?.name);
      print(defaultAnimeProvider?.name);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Providers')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(20),
            _defaultProviders(context),
          ],
        ),
      ),
    );
  }

  // Widget _chooseProvider(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Choose Providers', style: _titleTextStyle),
  //       addVerticalSpace(20),
  //     ],
  //   );
  // }

  _addPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: child,
    );
  }

  Widget _defaultProviders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _addPadding(Text('Default Providers', style: _titleTextStyle)),
        addVerticalSpace(20),
        _addPadding(Text('Movie and TV', style: labelTextStyle)),
        addVerticalSpace(10),
        _addPadding(
          SourceDropDownButton(
              providersList:
                  RepositoryProvider.of<ProvidersRepositoryContainer>(context)
                      .get<LoadProvidersUseCase>()
                      .call(MediaType.movie),
              selected: defaultMovieProvider,
              onSelected: (value) {
                if (value != defaultMovieProvider) {
                  RepositoryProvider.of<ProvidersRepositoryContainer>(context)
                      .get<SaveDefaultProviderUseCase>()
                      .call(SaveDefaultProviderUseCaseParams(
                        dirPath,
                        value,
                        _onDefaultProviderChanged,
                      ));
                  setState(() {
                    defaultMovieProvider = value;
                  });
                }
              }),
        ),
        addVerticalSpace(20),
        _addPadding(
          Text(
            'Anime',
            style: labelTextStyle,
          ),
        ),
        addVerticalSpace(10),
        _addPadding(
          SourceDropDownButton(
              providersList:
                  RepositoryProvider.of<ProvidersRepositoryContainer>(context)
                      .get<LoadProvidersUseCase>()
                      .call(MediaType.anime),
              selected: defaultAnimeProvider,
              onSelected: (value) {
                if (value != defaultAnimeProvider) {
                  RepositoryProvider.of<ProvidersRepositoryContainer>(context)
                      .get<SaveDefaultProviderUseCase>()
                      .call(SaveDefaultProviderUseCaseParams(
                          dirPath, value, _onDefaultProviderChanged));
                  setState(() {
                    defaultAnimeProvider = value;
                  });
                }
              }),
        )
      ],
    );
  }

  void _onDefaultProviderChanged() {
    showSnackBAr(context, text: 'Changed Default Provider');
  }
}
