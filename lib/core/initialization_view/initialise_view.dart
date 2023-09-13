import 'package:flutter/material.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';

abstract class InitialiseView {
  final MediaDetailsEntity media;

  final CacheRespository cacheRespository;

  final MetaProviderRepositoryContainer metaProviderRepositoryContainer;

  // final SelectedSearchResponseBloc selectedSearchResponseBloc;

  final SourceDropDownBloc sourceDropDownBloc;

  InitialiseView(
      {required this.media,
      required this.cacheRespository,
      required this.metaProviderRepositoryContainer,
      required this.sourceDropDownBloc
      // required this.selectedSearchResponseBloc,
// /    required this.sourceDropDownBloc,
      });

  void inject(List list);

  List<Widget> get selectors;

  void initalise();

  void dispose();

  Widget get selectedSearchResponseWidget;

  Widget get view;

  Widget get search;

  Widget createBlocProvider({required Widget child});
}
