part of 'search_page_bloc.dart';

sealed class SearchPageState extends Equatable {
  const SearchPageState();

  @override
  List<Object> get props => [];
}

final class SearchPageEmpty extends SearchPageState {
  const SearchPageEmpty();
}

final class SearchPageLoading extends SearchPageState {
  const SearchPageLoading();
}

final class SearchPageSucess extends SearchPageState {
  final MetaResultsEntity results;
  const SearchPageSucess(this.results);
}

final class SearchPageFailed extends SearchPageState {
  final MeiyouException error;
  const SearchPageFailed(this.error);
}
