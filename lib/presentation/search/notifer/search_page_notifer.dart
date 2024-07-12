import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SearchPageNotifer extends AsyncStateNotifier<SearchPage> {
  final Source source;
  final SourceRepository sourceRepository;
  SearchPageNotifer(
    this.source,
    this.sourceRepository,
  ) : super.data(const SearchPageIntial._());

  void search(int page, String query, FilterList filterList) {
    if (query.isEmpty) {
      setError(const PleaseSearchSomething._(), StackTrace.current);
    } else {
      setResultFuture(() =>
          sourceRepository.getSearchPage(source, page, query, filterList));
    }
  }

  Future<void> loadMore(int page, String query, FilterList filterList) async {
    assert(state.hasValue);
    if (!state.value!.hasNextPage) return;
    if (query.isEmpty) return;
    print('called');
    final result =
        await sourceRepository.getSearchPage(source, page, query, filterList);
    if (result.isSuccess) {
      setData(state.value! + result.getOrNull()!);
    }
  }
}

extension on SearchPage {
  SearchPage operator +(SearchPage other) {
    return SearchPage(
      hasNextPage: other.hasNextPage,
      items: [...items, ...other.items],
    );
  }
}

class SearchPageIntial extends SearchPage {
  const SearchPageIntial._()
      : super(
          hasNextPage: false,
          items: const [],
        );
}

class PleaseSearchSomething implements Exception {
  const PleaseSearchSomething._();
}
