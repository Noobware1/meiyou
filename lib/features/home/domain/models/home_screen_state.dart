import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

abstract class HomeScreenState {
  final InstalledSource? selectedSource;
  final AsyncValue<FullHomePageData> data;

  const HomeScreenState({required this.selectedSource, required this.data});
}

class HomeScreenStateNoSource extends HomeScreenState {
  const HomeScreenStateNoSource()
      : super(selectedSource: null, data: const AsyncValue.noData());
}

class HomeScreenStateWithSource extends HomeScreenState {
  @override
  InstalledSource get selectedSource => super.selectedSource!;

  const HomeScreenStateWithSource(
      {required InstalledSource super.selectedSource, required super.data});

  HomeScreenState copyWith(
      {InstalledSource? selectedSource, AsyncValue<FullHomePageData>? data}) {
    return HomeScreenStateWithSource(
      selectedSource: selectedSource ?? this.selectedSource,
      data: data ?? this.data,
    );
  }
}
