import 'dart:async';

import 'package:meiyou/core/utils/resources/async_cubit.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreenCubit extends AsyncCubit<HomeScreenData> {
  late final StreamSubscription<Source?> _streamSubscription;
  HomeScreenCubit(
    SelectedSource selectedSource,
    SourceRepository repository,
  ) : super.loading() {
    _streamSubscription = selectedSource.stream.listen(
      (source) => _load(source, repository),
    );
    _load(selectedSource.state, repository);
  }

  void _load(Source? source, SourceRepository repository) {
    if (source == null) {
      emitError(const NoSourceSelected());
      return;
    }
    if (!source.supportsHomePage) {
      emitError(const HomePageNotSupported());
      return;
    }
    future(() =>
        repository.getFullHomePage(source).then((value) => value.getOrThrow()));
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }
}

typedef HomeScreenData = Map<HomePageRequest, HomePage>;

class NoSourceSelected implements Exception {
  const NoSourceSelected();
  @override
  String toString() {
    return 'No source selected';
  }
}

class HomePageNotSupported implements Exception {
  const HomePageNotSupported();
  @override
  String toString() {
    return 'Home page not supported';
  }
}
