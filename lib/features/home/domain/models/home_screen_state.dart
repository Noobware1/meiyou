import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/home_page_data.dart';
import 'package:meiyou/shared/domain/models/source.dart';

abstract class HomeScreenState {
  final InstalledSource? selectedSource;
  final AsyncValue<List<HomePageData>> data;

  const HomeScreenState({required this.selectedSource, required this.data});

  T when<T>(
      {required T Function() noSource,
      required T Function(InstalledSource selectedSource,
              AsyncValue<List<HomePageData>> data)
          withSource});
}

class HomeScreenStateNoSource extends HomeScreenState {
  const HomeScreenStateNoSource()
      : super(selectedSource: null, data: const AsyncValue.noData());

  @override
  T when<T>(
          {required T Function() noSource,
          required T Function(InstalledSource selectedSource,
                  AsyncValue<List<HomePageData>> data)
              withSource}) =>
      noSource();
}

class HomeScreenStateWithSource extends HomeScreenState {
  @override
  InstalledSource get selectedSource => super.selectedSource!;

  const HomeScreenStateWithSource(
      {required InstalledSource super.selectedSource, required super.data});

  HomeScreenState copyWith(
      {InstalledSource? selectedSource, AsyncValue<List<HomePageData>>? data}) {
    return HomeScreenStateWithSource(
      selectedSource: selectedSource ?? this.selectedSource,
      data: data ?? this.data,
    );
  }

  @override
  T when<T>(
          {required T Function() noSource,
          required T Function(InstalledSource selectedSource,
                  AsyncValue<List<HomePageData>> data)
              withSource}) =>
      withSource(selectedSource, data);
}
