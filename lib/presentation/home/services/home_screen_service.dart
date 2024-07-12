import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreenNotifer extends AsyncStateNotifier<HomeScreenData> {
  HomeScreenNotifer(
    Source? source,
  ) : super.loading();

  void load(Source? source) {
    if (source == null) {
      setError(const NoSourceSelected());
      return;
    }
    if (!source.supportsHomePage) {
      setError(const HomePageNotSupported());
      return;
    }
    setFuture(() => getIt
        .get<SourceRepository>()
        .getFullHomePage(source)
        .then((value) => value.getOrThrow()));
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
